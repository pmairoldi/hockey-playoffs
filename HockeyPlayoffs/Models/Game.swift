import Foundation
import RealmSwift

class Game: Object, Codable {
    @objc dynamic var active: Bool = true
    @objc dynamic var awayCondense: String = ""
    @objc dynamic var awayHighlight: String = ""
    @objc dynamic var awayId: String = ""
    @objc dynamic var awayScore: Int = 0
    @objc dynamic var date: String = ""
    @objc dynamic var gameId: String = ""
    @objc dynamic var homeCondense: String = ""
    @objc dynamic var homeHighlight: String = ""
    @objc dynamic var homeId: String = ""
    @objc dynamic var homeScore: Int = 0
    @objc dynamic var homeStatus: String = ""
    @objc dynamic var period: Int = 0 //TODO: make enum of 1, 2, 3, ot(Int = 0)
    @objc dynamic var periodTime: String = ""
    @objc dynamic var seasonId: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var tv: String = ""

    let periods: List<Period> = List<Period>()
    let events: List<Event> = List<Event>()

    enum CodingKeys: String, CodingKey {
        case active
        case awayCondense
        case awayHighlight
        case awayId = "awayID"
        case awayScore
        case date
        case gameId = "gameID"
        case homeCondense
        case homeHighlight
        case homeId = "homeID"
        case homeScore
        case homeStatus
        case period
        case periodTime
        case seasonId = "seasonID"
        case time
        case tv
    }
}