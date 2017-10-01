import Foundation
import RealmSwift

class Matchup: Object, Codable {
    @objc private dynamic var seasonId: String = ""
    @objc private dynamic var topTeamId: String?
    @objc private dynamic var bottomTeamId: String?
    @objc private dynamic var conferenceId: String = ""
    @objc private dynamic var roundId: Int = 0
    @objc private dynamic var seedId: Int = 0

    let games: List<Game> = List<Game>()

    var id: String {
        return "\(seasonId)0\(roundId)\(round.seed)"
    }

    var topTeam: Team? {
        return seriesTeam(teamId: topTeamId, wins: teamWins(teamId: topTeamId))
    }

    var bottomTeam: Team? {
        return seriesTeam(teamId: bottomTeamId, wins: teamWins(teamId: bottomTeamId))
    }

    var conference: Conference? {
        return Conference(rawValue: conferenceId)
    }

    var round: Round {
        return Round(conference: conference, round: roundId, series: seedId)
    }

    var hasGameToday: Bool {
        return true
    }

    fileprivate func seriesTeam(teamId: String?, wins: Int) -> Team? {
        guard let teamId = teamId, let team = Teams(rawValue: teamId) else {
            return nil
        }
        return Team(team: team, wins: wins)
    }

    fileprivate func teamWins(teamId: String?) -> Int {
        guard let teamId = teamId else {
            return 0
        }

        let predicate = "(awayId = '\(teamId)' AND awayScore > homeScore) OR (homeId = '\(teamId)' AND homeScore > awayScore)"

        return games.filter(predicate).count
    }

    enum CodingKeys: String, CodingKey {
        case seasonId = "seasonID"
        case topTeamId = "homeID"
        case bottomTeamId = "awayID"
        case conferenceId = "conference"
        case roundId = "round"
        case seedId = "seed"
    }
}
