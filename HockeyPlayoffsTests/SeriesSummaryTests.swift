import SQLite3
import UIKit
import XCTest

@testable import HockeyPlayoffs

@MainActor
final class SeriesSummaryTests: XCTestCase {
    func testSeriesOutcomeDescriptions() {
        let cases: [(top: String, bottom: String, topWins: Int, bottomWins: Int, expected: String)] = [
            ("tbl", "mtl", 0, 0, "Series not started"),
            ("tbl", "mtl", 2, 2, "Series tied 2–2"),
            ("tbl", "mtl", 3, 1, "TBL leads series 3–1"),
            ("tbl", "mtl", 1, 3, "MTL leads series 3–1"),
            ("tbl", "mtl", 4, 0, "TBL wins series 4–0"),
            ("tbl", "mtl", 3, 4, "MTL wins series 4–3"),
            ("tbl", "", 0, 0, "Matchup to be determined"),
            ("", "", 0, 0, "Matchup to be determined"),
        ]
        for example in cases {
            let series = SeriesObject()
            series.topTeam = example.top
            series.bottomTeam = example.bottom
            series.topWins = example.topWins
            series.bottomWins = example.bottomWins
            XCTAssertEqual(
                series.summaryTitle, example.expected,
                "Incorrect summary for \(example.top) \(example.topWins)–\(example.bottomWins) \(example.bottom)")
        }
    }

    func testConditionalGameTitlesFollowBestOfSevenStandings() {
        let cases: [(home: Int, away: Int, conditional: Set<Int>)] = [
            (0, 0, [5, 6, 7]), (1, 0, [5, 6, 7]), (1, 1, [6, 7]),
            (2, 1, [6, 7]), (2, 2, [7]), (3, 0, [5, 6, 7]),
            (3, 1, [6, 7]), (3, 2, [7]), (3, 3, []), (4, 0, []),
            (0, 3, [5, 6, 7]), (1, 3, [6, 7]), (2, 3, [7]), (0, 4, []),
        ]
        for example in cases {
            for number in 1...7 {
                let game = GameObject(["gameID": "209903012\(number)", "homeID": "col", "awayID": "min"])
                game.seriesWins = ["col": example.home, "min": example.away]
                let expected =
                    example.conditional.contains(number)
                    ? "Game \(number) · If necessary" : "Game \(number)"
                XCTAssertEqual(
                    game.overviewTitle, expected,
                    "Incorrect game label at \(example.home)–\(example.away)")
            }
        }
    }

    func testConditionalCopyIsNotShownForStartedGamesOrUnknownContext() {
        for state in ["unknown", "started", "finished", "period", "final", "inactive"] {
            let game = GameObject(["gameID": "2099030125", "homeID": "col", "awayID": "min"])
            if state != "unknown" { game.seriesWins = [:] }
            switch state {
            case "started": game.started = true
            case "finished": game.finished = true
            case "period": game.period = 1
            case "final": game.periodTime = "FINAL"
            case "inactive": game.active = false
            default: break
            }
            XCTAssertEqual(game.overviewTitle, "Game 5", state)
        }
        for id in ["", "2099020125", "2099030120", "2099030128"] {
            let game = GameObject(["gameID": id])
            game.seriesWins = [:]
            XCTAssertEqual(game.overviewTitle, "Game", "Do not infer playoff game numbers from an invalid ID")
        }
    }

    func testFilteredDatabaseReadsUseTheFullSeriesAndRefreshItsStandings() throws {
        let store = DatabaseHandler.shared
        let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("hockey.sqlite")
        var connection: OpaquePointer?
        XCTAssertEqual(sqlite3_open(url.path, &connection), SQLITE_OK)
        let db = try XCTUnwrap(connection)
        defer { sqlite3_close(db) }
        func execute(_ sql: String) throws {
            guard sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK else {
                throw NSError(
                    domain: "SeriesFixture", code: 1,
                    userInfo: [NSLocalizedDescriptionKey: String(cString: sqlite3_errmsg(db))])
            }
        }
        // Isolated future IDs: never replace or delete the app's real games.
        let cleanup =
            "DELETE FROM periods WHERE game_id LIKE '209903012%'; DELETE FROM games WHERE game_id LIKE '209903012%';"
        defer {
            _ = sqlite3_exec(db, "ROLLBACK", nil, nil, nil)
            try? execute(cleanup)
        }
        try execute(
            """
            BEGIN;
            \(cleanup)
            INSERT INTO games (game_id, home_id, away_id, season_id, date, period, period_time, finished) VALUES
                ('2099030121', 'col', 'min', '209903', '2099-04-19', 3, 'FINAL', 1),
                ('2099030122', 'col', 'min', '209903', '2099-04-20', 3, 'FINAL', 1),
                ('2099030125', 'col', 'min', '209903', '2099-04-21', 0, '', 0);
            INSERT INTO periods (game_id, team_id, period, goals) VALUES
                ('2099030121', 'col', 1, 2), ('2099030121', 'min', 1, 1),
                ('2099030122', 'col', 1, 2), ('2099030122', 'min', 1, 1);
            COMMIT;
            """
        )
        let series = SeriesObject()
        series.seasonID = "209903"
        series.round = 1
        series.seed = 2
        series.conference = "e"
        let day = try XCTUnwrap(ISO8601DateFormatter().date(from: "2099-04-21T17:00:00Z"))
        XCTAssertEqual(store.getGameForID("2099030125")?.overviewTitle, "Game 5 · If necessary")
        XCTAssertEqual(
            store.getGamesForDate(day).first { $0.gameID == "2099030125" }?.overviewTitle,
            "Game 5 · If necessary")
        XCTAssertEqual(
            store.getGamesForSeries(series).first { $0.gameID == "2099030125" }?.overviewTitle,
            "Game 5 · If necessary")
        // A split series guarantees Game 5. Reloading must remove the qualifier.
        try execute("UPDATE periods SET goals = 3 WHERE game_id = '2099030122' AND team_id = 'min'")
        XCTAssertEqual(store.getGameForID("2099030125")?.overviewTitle, "Game 5")
        XCTAssertEqual(
            store.getGamesForDate(day).first { $0.gameID == "2099030125" }?.overviewTitle, "Game 5",
            "The date-filtered list must not infer standings from only that day's games")
    }

    func testOverviewUpdatesItsGameLabelWhenReused() throws {
        let scene = try XCTUnwrap(UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first)
        let previousWindow = scene.windows.first { $0.isKeyWindow }
        let window = UIWindow(windowScene: scene)
        let controller = UIViewController()
        window.rootViewController = controller
        window.makeKeyAndVisible()
        defer {
            window.isHidden = true
            previousWindow?.makeKeyAndVisible()
        }
        let view = GameOverviewView()
        controller.view.addSubview(view)
        view.bounds = CGRect(x: 0, y: 0, width: 362, height: GameOverviewView.height)
        view.backgroundColor = Colors.gameBackgroundColor()
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        let future = GameObject([
            "gameID": "2099030125", "homeID": "col", "awayID": "min",
            "date": "2099-04-21", "time": "19:00:00",
        ])
        future.seriesWins = ["col": 3, "min": 0]
        func texts(in parent: UIView) -> [String] {
            (parent as? UILabel).flatMap { $0.text }.map { [$0] } ?? parent.subviews.flatMap { texts(in: $0) }
        }
        func capture(_ name: String) {
            window.layoutIfNeeded()
            view.layoutIfNeeded()
            let image = UIGraphicsImageRenderer(size: view.bounds.size).image { view.layer.render(in: $0.cgContext) }
            let attachment = XCTAttachment(image: image)
            attachment.name = name
            attachment.lifetime = .keepAlways
            add(attachment)
        }
        for style in [UIUserInterfaceStyle.light, .dark] {
            view.overrideUserInterfaceStyle = style
            view.setGame(future)
            XCTAssertTrue(texts(in: view).contains("Game 5 · If necessary"))
            capture("Conditional-Game-\(style.rawValue)")
            let final = GameObject([
                "gameID": "2099030124", "homeID": "col", "awayID": "min",
                "period": 3, "periodTime": "FINAL", "finished": 1,
            ])
            final.homeScore = 9
            final.awayScore = 6
            view.setGame(final)
            XCTAssertTrue(texts(in: view).contains("Game 4"))
            XCTAssertFalse(texts(in: view).contains("Game 5 · If necessary"))
            capture("Completed-Game-\(style.rawValue)")
        }
    }
}
