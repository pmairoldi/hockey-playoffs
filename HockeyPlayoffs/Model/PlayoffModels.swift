import UIKit

@MainActor
final class BracketModel {
    static let counts = [4, 2, 1, 1, 1, 2, 4]
    private var series: [SeriesObject] = []
    var isRefreshing = false
    func refresh() { series = DatabaseHandler.shared.getPlayoffsTree() }
    func getSeriesAtIndex(_ index: IndexPath) -> SeriesObject? {
        let round = [1, 2, 3, 4, 3, 2, 1][index.section]
        let conference = index.section < 3 ? "w" : index.section == 3 ? "f" : "e"
        return series.first { $0.round == round && $0.conference == conference && $0.seed == index.item + 1 }
    }
}

@MainActor
final class SeriesModel {
    private(set) var series: SeriesObject
    private(set) var games: [GameObject] = []
    var isRefreshing = false
    init(series: SeriesObject) { self.series = series }
    var hasTeams: Bool { !series.topTeam.isEmpty || !series.bottomTeam.isEmpty }
    func refresh() {
        series = DatabaseHandler.shared.getSeries(series)
        games = DatabaseHandler.shared.getGamesForSeries(series)
    }
}

@MainActor
final class RecentGamesModel {
    var date: Date
    private(set) var games: [GameObject] = []
    var isRefreshing = false
    init() {
        let now = DateTimeHandler.now()
        date =
            Calendar.current.component(.hour, from: now) < 12
            ? Calendar.current.date(byAdding: .day, value: -1, to: now)! : now
    }
    func refresh() { games = DatabaseHandler.shared.getGamesForDate(date) }
}

@MainActor
final class GameModel {
    var sectionIndex = 0
    private(set) var game: GameObject
    private(set) var periods: [PeriodObject] = []
    private var events: [EventObject] = []
    var isRefreshing = false
    init(game: GameObject) { self.game = game }
    var numberOfSections: Int { 1 + max(periods.map(\.period).max() ?? 0, 3) }
    var hasOTPeriod: Bool { game.period >= 4 }
    var otPeriod: Int { max(0, game.period - 3) }
    var noDataText: String { localized(sectionIndex == 0 ? "game.nogoals" : "game.nopenalties") }
    func events(in period: Int) -> [EventObject] {
        events.filter { $0.period == period && $0.type == (sectionIndex == 0 ? "goal" : "penalty") }
    }
    func score(for team: String, period: Int) -> Int { periodObject(team, period)?.goals ?? 0 }
    private func periodObject(_ team: String, _ period: Int) -> PeriodObject? {
        if period == 4 { return periods.last { $0.teamID == team && $0.period >= 4 } }
        return periods.first { $0.teamID == team && $0.period == period }
    }
    func refresh() {
        if let updated = DatabaseHandler.shared.getGameForID(game.gameID) { game = updated }
        periods = DatabaseHandler.shared.getPeriodsForGameID(game.gameID)
        events = DatabaseHandler.shared.getEventsForGameID(game.gameID)
    }
}
