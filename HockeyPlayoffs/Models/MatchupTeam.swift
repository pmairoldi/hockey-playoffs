import Foundation
import RealmSwift

class MatchupTeam: Object, Codable {
    @objc dynamic var team: Team?
    @objc dynamic var wins: Int = 0

    enum CodingKeys: String, CodingKey {
        case team
        case wins
    }
}
