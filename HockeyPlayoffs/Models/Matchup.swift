import Foundation
import RealmSwift

class Matchup: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var topTeam: MatchTeam?
    @objc dynamic var bottomTeam: MatchTeam?
    @objc private dynamic var roundId: Int = 0
    @objc private dynamic var seedId: Int = 0
    var games: List<Game> = List<Game>()

    var round: Round {
        return Round(round: roundId, series: seedId)
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
        case roundId = "round"
        case seedId = "seed"
        case games
    }
}
