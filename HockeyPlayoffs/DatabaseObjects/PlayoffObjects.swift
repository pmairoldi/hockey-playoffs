import Foundation

final class GameObject {
    var gameID = ""
    var awayID = ""
    var homeID = ""
    var homeScore = 0
    var awayScore = 0
    var homeShots = 0
    var awayShots = 0
    var date = ""
    var time = ""
    var tv = ""
    var period = 0
    var periodTime = ""
    var homeStatus = ""
    var awayStatus = ""
    var seasonID = ""
    var started = false
    var finished = false
    var homeHighlight = ""
    var awayHighlight = ""
    var homeCondense = ""
    var awayCondense = ""
    var active = true
    // Hydrated from the entire series, even for single-game and date-filtered reads.
    var seriesWins: [String: Int]?
    init(_ values: [String: Any] = [:]) {
        gameID = values.string("gameID")
        awayID = values.string("awayID")
        homeID = values.string("homeID")
        date = values.string("date")
        time = values.string("time")
        tv = values.string("tv")
        period = values.integer("period")
        periodTime = values.string("periodTime")
        homeStatus = values.string("homeStatus")
        awayStatus = values.string("awayStatus")
        seasonID = values.string("seasonID")
        started = values.integer("started") != 0
        finished = values.integer("finished") != 0
        homeHighlight = values.string("homeHighlight")
        awayHighlight = values.string("awayHighlight")
        homeCondense = values.string("homeCondense")
        awayCondense = values.string("awayCondense")
        active = values["active"] == nil || values.integer("active") != 0
    }
    func getScoreForTeam(_ team: String) -> Int { team == homeID ? homeScore : team == awayID ? awayScore : 0 }
    func hasWonGame(_ team: String) -> Bool { team == homeID ? homeScore > awayScore : awayScore > homeScore }
    var hasVideo: Bool { !homeHighlight.isEmpty || !awayHighlight.isEmpty }
    var videoLinks: [URL] { [homeHighlight, awayHighlight].filter { !$0.isEmpty }.compactMap(URL.init(string:)) }
    var relativeGameID: String { String(gameID.dropFirst(7)) }
    var number: Int? {
        guard gameID.count == 10, gameID.dropFirst(4).hasPrefix("03"),
            let number = Int(gameID.suffix(1)), (1...7).contains(number)
        else { return nil }
        return number
    }
    var hasStarted: Bool { started || finished || period > 0 || periodTime == "FINAL" }
    var isIfNecessary: Bool {
        guard let number, !hasStarted, active, let seriesWins else { return false }
        let homeWins = seriesWins[homeID, default: 0]
        let awayWins = seriesWins[awayID, default: 0]
        guard max(homeWins, awayWins) < 4 else { return false }
        // A best-of-seven series guarantees four games plus the trailing team's wins.
        return number > 4 + min(homeWins, awayWins)
    }
    var title: String {
        number.map { "\(localized("game.title")) \($0)" } ?? localized("game.title")
    }
    var overviewTitle: String {
        isIfNecessary
            ? String.localizedStringWithFormat(localized("game.title.ifNecessary"), title)
            : title
    }
    var status: String {
        if period == 0 {
            let day = DateTimeHandler.getDateForDate(date, andTime: time)
            let hour = DateTimeHandler.getTimeForDate(date, andTime: time)
            return day.isEmpty ? hour : "\(day)\n\(hour)"
        }
        return "\(periodTime.isEmpty ? "20:00" : localized(periodTime))\n\(periodTitle(period, short: true))"
    }
}

final class PeriodObject {
    var gameID = ""
    var teamID = ""
    var period = 0
    var shots = 0
    var goals = 0
    init(_ values: [String: Any] = [:]) {
        gameID = values.string("gameID")
        teamID = values.string("teamID")
        period = values.integer("period")
        shots = values.integer("shots")
        goals = values.integer("goals")
    }
}

final class EventObject {
    var eventID = 0
    var gameID = ""
    var teamID = ""
    var period = 0
    var time = ""
    var type = ""
    var details = ""
    var videoLink = ""
    var formalID = ""
    var strength = ""
    init(_ values: [String: Any] = [:]) {
        eventID = values.integer("eventID")
        gameID = values.string("gameID")
        teamID = values.string("teamID")
        period = values.integer("period")
        time = values.string("time")
        type = values.string("type")
        details = values.string("description")
        videoLink = values.string("videoLink")
        formalID = values.string("formalID")
        strength = values.string("strength")
    }
}

final class TeamObject {
    var seasonID = ""
    var homeID = ""
    var awayID = ""
    var conference = ""
    var round = 0
    var seed = 0
    init(_ values: [String: Any] = [:]) {
        seasonID = values.string("seasonID")
        homeID = values.string("homeID")
        awayID = values.string("awayID")
        conference = values.string("conference")
        round = values.integer("round")
        seed = values.integer("seed")
    }
}

final class SeriesObject {
    var seasonID = ""
    var topTeam = ""
    var bottomTeam = ""
    var conference = ""
    var seed = 0
    var round = 0
    var topWins = 0
    var bottomWins = 0
    var hasGameToday = false
    private var normalizedSeed: Int { seed + (conference == "w" ? [1: 4, 2: 2, 3: 1][round, default: 0] : 0) }
    var seriesID: String { "\(seasonID)0\(round)\(normalizedSeed)%" }
    var relativeSeriesID: String { "\(round)\(normalizedSeed)" }
    var summaryTitle: String {
        guard !topTeam.isEmpty, !bottomTeam.isEmpty else { return localized("series.summary.pending") }
        if topWins == 0 && bottomWins == 0 { return localized("series.summary.upcoming") }
        if topWins == bottomWins {
            return String.localizedStringWithFormat(localized("series.summary.tied"), topWins, bottomWins)
        }
        let topLeads = topWins > bottomWins
        let leader = topLeads ? topTeam : bottomTeam
        let wins = topLeads ? topWins : bottomWins
        let losses = topLeads ? bottomWins : topWins
        let key = wins >= 4 ? "series.summary.won" : "series.summary.leads"
        return String.localizedStringWithFormat(localized(key), leader.uppercased(), wins, losses)
    }
    var title: String {
        if round == 4 { return localized("controller.bracket.final") }
        let name = [1: "quarter", 2: "semi", 3: "final"][round] ?? ""
        return localized("controller.bracket.\(name).\(conference == "w" ? "west" : "east")")
    }
}

func periodTitle(_ period: Int, short: Bool = false) -> String {
    let suffix = short ? ".short" : ""
    switch period {
    case 0: return ""
    case 1: return localized("period.first" + suffix)
    case 2: return localized("period.second" + suffix)
    case 3: return localized("period.third" + suffix)
    case 4: return localized("period.ot" + suffix)
    case 5: return localized("period.second" + suffix) + " " + localized("period.ot" + suffix)
    case 6: return localized("period.third" + suffix) + " " + localized("period.ot" + suffix)
    default: return "\(period - 3)\(localized("period.number.ending")) \(localized("period.ot" + suffix))"
    }
}
