import FMDB
import Foundation

// FMDatabaseQueue serializes every read, migration and transaction. The on-disk
// schema and Library/hockey.sqlite location are unchanged for existing installs.
final class DatabaseHandler: @unchecked Sendable {
    static let shared = DatabaseHandler()
    private let queue: FMDatabaseQueue

    private init() {
        let library = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let url = library.appendingPathComponent("hockey.sqlite")
        do {
            if !FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.copyItem(
                    at: Bundle.main.url(forResource: "hockey", withExtension: "sqlite")!, to: url)
            }
        } catch { fatalError("Cannot create database: \(error)") }
        guard let queue = FMDatabaseQueue(path: url.path) else { fatalError("Cannot open database") }
        self.queue = queue
        queue.inDatabase { db in
            for component in ["red", "green", "blue"] {
                let columns = Self.rows(db, "PRAGMA table_info(teams)")
                if !columns.contains(where: { $0.string("name") == component }) {
                    _ = db.executeUpdate(
                        "ALTER TABLE teams ADD COLUMN \(component) TINYINT NOT NULL DEFAULT 0", withArgumentsIn: [])
                }
            }
            if let url = Bundle.main.url(forResource: "teams", withExtension: "json"),
                let data = try? Data(contentsOf: url),
                let teams = (try? JSONSerialization.jsonObject(with: data)) as? [String: [String: Any]]
            {
                for (id, team) in teams {
                    let color = team["color"] as? [String: Any] ?? [:]
                    _ = db.executeUpdate(
                        "UPDATE teams SET red = ?, green = ?, blue = ? WHERE team_id = ?",
                        withArgumentsIn: [color.integer("red"), color.integer("green"), color.integer("blue"), id])
                }
            }
        }
    }
    func close() { queue.close() }

    private static func rows(_ db: FMDatabase, _ sql: String, _ arguments: [Any] = []) -> [[String: Any]] {
        guard let results = db.executeQuery(sql, withArgumentsIn: arguments) else { return [] }
        defer { results.close() }
        var rows: [[String: Any]] = []
        while results.next() { rows.append(results.resultDictionary as? [String: Any] ?? [:]) }
        return rows
    }
    private func read<T>(_ work: (FMDatabase) -> T) -> T {
        var result: T!
        queue.inDatabase { result = work($0) }
        return result
    }

    // The API supplies a complete active-game snapshot. Bind each ID separately
    // (a comma-joined string is not a SQL IN list). Roll back failed updates.
    func updatePlayoffData(_ data: [String: Any]) throws {
        var failure: Error?
        queue.inTransaction { db, rollback in
            do {
                let games = data["games"] as? [[String: Any]] ?? []
                let events = data["events"] as? [[String: Any]] ?? []
                for (table, records) in [("games", games), ("events", events)] where !records.isEmpty {
                    let ids = Array(Set(records.map { $0.string("gameID") }))
                    let marks = Array(repeating: "?", count: ids.count).joined(separator: ",")
                    try db.executeUpdate("DELETE FROM \(table) WHERE game_id NOT IN (\(marks))", values: ids)
                }
                for values in games {
                    let game = GameObject(values)
                    if !game.active {
                        try db.executeUpdate("DELETE FROM games WHERE game_id = ?", values: [game.gameID])
                        continue
                    }
                    try db.executeUpdate(
                        "INSERT OR REPLACE INTO games (game_id,away_id,home_id,date,time,tv,period,period_time,home_status,away_status,season_id,started,finished,home_highlight,away_highlight,home_condense,away_condense) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                        values: [
                            game.gameID, game.awayID, game.homeID, game.date, game.time, game.tv, game.period,
                            game.periodTime, game.homeStatus, game.awayStatus, game.seasonID, game.started,
                            game.finished, game.homeHighlight, game.awayHighlight, game.homeCondense, game.awayCondense,
                        ])
                }
                for value in data["periods"] as? [[String: Any]] ?? [] {
                    let p = PeriodObject(value)
                    try db.executeUpdate(
                        "INSERT OR REPLACE INTO periods (game_id,team_id,period,shots,goals) VALUES (?,?,?,?,?)",
                        values: [p.gameID, p.teamID, p.period, p.shots, p.goals])
                }
                for value in data["teams"] as? [[String: Any]] ?? [] {
                    let t = TeamObject(value)
                    try db.executeUpdate(
                        "INSERT OR REPLACE INTO playoff_seeds (season_id,home_id,away_id,conference,round,seed) VALUES (?,?,?,?,?,?)",
                        values: [t.seasonID, t.homeID, t.awayID, t.conference, t.round, t.seed])
                }
                for value in events {
                    let e = EventObject(value)
                    try db.executeUpdate(
                        "INSERT OR REPLACE INTO events (id,game_id,team_id,period,time,type,description,video_link,formal_id,strength) VALUES (?,?,?,?,?,?,?,?,?,?)",
                        values: [
                            e.eventID, e.gameID, e.teamID, e.period, e.time, e.type, e.details, e.videoLink, e.formalID,
                            e.strength,
                        ])
                }
            } catch {
                failure = error
                rollback.pointee = true
            }
        }
        if let failure { throw failure }
    }

    func getPlayoffsTree() -> [SeriesObject] {
        read { db in
            let season =
                Self.rows(db, "SELECT MAX(season_id) AS season_id FROM playoff_seeds").first?.string("season_id") ?? ""
            var series: [SeriesObject] = []
            for round in 1...4 {
                for conference in round == 4 ? ["f"] : ["e", "w"] {
                    for seed in 1...(round == 1 ? 4 : round == 2 ? 2 : 1) {
                        let object = SeriesObject()
                        object.seasonID = season
                        object.round = round
                        object.conference = conference
                        object.seed = seed
                        series.append(Self.series(object, db))
                    }
                }
            }
            return series
        }
    }
    func getSeries(_ original: SeriesObject) -> SeriesObject {
        read { db in
            let object = SeriesObject()
            object.seasonID = original.seasonID
            object.round = original.round
            object.seed = original.seed
            object.conference = original.conference
            return Self.series(object, db)
        }
    }
    private static func series(_ object: SeriesObject, _ db: FMDatabase) -> SeriesObject {
        let row = rows(
            db, "SELECT * FROM playoff_seeds WHERE season_id = ? AND round = ? AND seed = ? AND conference = ?",
            [object.seasonID, object.round, object.seed, object.conference]
        ).first
        let games = games(db, "game_id LIKE ?", [object.seriesID])
        object.topTeam = row?.string("home_id") ?? ""
        object.bottomTeam = row?.string("away_id") ?? ""
        if object.topTeam.isEmpty { object.topTeam = games.first?.homeID ?? "" }
        if object.bottomTeam.isEmpty { object.bottomTeam = games.first?.awayID ?? "" }
        object.hasGameToday = games.contains {
            $0.date <= DateTimeHandler.getStringFor(DateTimeHandler.now()) && $0.periodTime != "FINAL"
        }
        for game in games where game.periodTime == "FINAL" {
            if game.hasWonGame(object.topTeam) { object.topWins += 1 }
            if game.hasWonGame(object.bottomTeam) { object.bottomWins += 1 }
        }
        return object
    }
    private static func games(_ db: FMDatabase, _ predicate: String, _ arguments: [Any], order: String = "game_id ASC")
        -> [GameObject]
    {
        let games = rows(db, "SELECT * FROM games WHERE \(predicate) ORDER BY \(order)", arguments).map { row in
            let game = GameObject()
            game.gameID = row.string("game_id")
            game.homeID = row.string("home_id")
            game.awayID = row.string("away_id")
            game.date = row.string("date")
            game.time = row.string("time")
            game.tv = row.string("tv")
            game.period = row.integer("period")
            game.periodTime = row.string("period_time")
            game.homeStatus = row.string("home_status")
            game.awayStatus = row.string("away_status")
            game.seasonID = row.string("season_id")
            game.started = row.integer("started") != 0
            game.finished = row.integer("finished") != 0
            game.homeHighlight = row.string("home_highlight")
            game.awayHighlight = row.string("away_highlight")
            game.homeCondense = row.string("home_condense")
            game.awayCondense = row.string("away_condense")
            for period in rows(
                db,
                "SELECT team_id, SUM(goals) AS goals, SUM(shots) AS shots FROM periods WHERE game_id = ? GROUP BY team_id",
                [game.gameID])
            {
                if period.string("team_id") == game.homeID {
                    game.homeScore = period.integer("goals")
                    game.homeShots = period.integer("shots")
                }
                if period.string("team_id") == game.awayID {
                    game.awayScore = period.integer("goals")
                    game.awayShots = period.integer("shots")
                }
            }
            return game
        }
        var standings: [String: [String: Int]] = [:]
        for game in games where !game.hasStarted && (game.number ?? 0) > 4 {
            let seriesID = String(game.gameID.dropLast()) + "%"
            if standings[seriesID] == nil {
                var wins: [String: Int] = [:]
                let results = rows(
                    db,
                    """
                    SELECT g.home_id, g.away_id,
                        COALESCE(SUM(CASE WHEN p.team_id = g.home_id THEN p.goals ELSE 0 END), 0) AS home_goals,
                        COALESCE(SUM(CASE WHEN p.team_id = g.away_id THEN p.goals ELSE 0 END), 0) AS away_goals
                    FROM games g LEFT JOIN periods p ON p.game_id = g.game_id
                    WHERE g.game_id LIKE ? AND (g.period_time = 'FINAL' OR g.finished != 0)
                    GROUP BY g.game_id
                    """, [seriesID])
                for result in results {
                    let home = result.integer("home_goals")
                    let away = result.integer("away_goals")
                    if home != away {
                        let winner = result.string(home > away ? "home_id" : "away_id")
                        wins[winner, default: 0] += 1
                    }
                }
                standings[seriesID] = wins
            }
            game.seriesWins = standings[seriesID]
        }
        return games
    }
    func getGamesForSeries(_ series: SeriesObject) -> [GameObject] {
        read { Self.games($0, "game_id LIKE ?", [series.seriesID]) }
    }
    func getGameForID(_ id: String) -> GameObject? { read { Self.games($0, "game_id = ?", [id]).first } }
    func getGamesForDate(_ date: Date) -> [GameObject] {
        read {
            Self.games($0, "date = ?", [DateTimeHandler.getStringFor(date)], order: "time ASC, date ASC, game_id ASC")
        }
    }
    func getPeriodsForGameID(_ id: String) -> [PeriodObject] {
        read { db in
            Self.rows(db, "SELECT * FROM periods WHERE game_id = ? ORDER BY period ASC", [id]).map { row in
                let period = PeriodObject()
                period.gameID = row.string("game_id")
                period.teamID = row.string("team_id")
                period.period = row.integer("period")
                period.shots = row.integer("shots")
                period.goals = row.integer("goals")
                return period
            }
        }
    }
    func getEventsForGameID(_ id: String) -> [EventObject] {
        read { db in
            Self.rows(db, "SELECT * FROM events WHERE game_id = ? ORDER BY period ASC, time ASC", [id]).map { row in
                let event = EventObject()
                event.eventID = row.integer("id")
                event.gameID = row.string("game_id")
                event.teamID = row.string("team_id")
                event.period = row.integer("period")
                event.time = row.string("time")
                event.type = row.string("type")
                event.details = row.string("description")
                event.videoLink = row.string("video_link")
                event.formalID = row.string("formal_id")
                event.strength = row.string("strength")
                return event
            }
        }
    }
}
