import Foundation
import RealmSwift

class Game: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var awayTeam: GameTeam?
    @objc dynamic var homeTeam: GameTeam?
    @objc dynamic var period: Int = 0 //TODO: make enum of 1, 2, 3, ot(Int = 0)
    @objc dynamic var periodTime: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var tv: String = ""
    @objc dynamic var active: Bool = true

    let periods: List<Period> = List<Period>()
    let events: List<Event> = List<Event>()

    override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case awayTeam
        case homeTeam
        case period
        case periodTime
        case date
        case time
        case tv
        case active
    }
}
