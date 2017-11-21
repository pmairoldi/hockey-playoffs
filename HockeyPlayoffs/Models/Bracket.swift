import Foundation
import RealmSwift

class Bracket: Object, Codable {
    @objc dynamic var year: String = ""
    var matchups: List<Matchup> = List<Matchup>()

    override static func primaryKey() -> String? {
        return "year"
    }

    enum CodingKeys: String, CodingKey {
        case year
        case matchups
    }
}
