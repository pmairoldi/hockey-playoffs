import Foundation
import RealmSwift

class Team: Object, Codable {
    @objc dynamic var abbreviation: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""

    override static func primaryKey() -> String? {
        return "abbreviation"
    }

    enum CodingKeys: String, CodingKey {
        case abbreviation
        case city
        case name
        case color
    }
}
