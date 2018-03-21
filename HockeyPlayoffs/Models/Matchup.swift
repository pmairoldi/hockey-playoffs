import Foundation
import RealmSwift

class Matchup: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var topTeam: MatchupTeam?
    @objc dynamic var bottomTeam: MatchupTeam?
    @objc private dynamic var round: Int = 0
    @objc private dynamic var seed: Int = 0
    var games: List<Game> = List<Game>()

    var series: Series {
        return Series(round: round, seed: seed)
    }

    var hasGameToday: Bool {
        return true
    }

    override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case topTeam
        case bottomTeam
        case round
        case seed
        case games
    }
}
