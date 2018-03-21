import Foundation
import RealmSwift

class GameTeam: Object, Codable {
    @objc dynamic var team: Team?
    @objc dynamic var score: Int = 0
    @objc dynamic var status: String = ""
    @objc dynamic var condense: String?
    @objc dynamic var highlight: String?

    enum CodingKeys: String, CodingKey {
        case team
        case score
        case status
        case condense
        case highlight
    }
}
