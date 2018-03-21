import Foundation
import RealmSwift

class Event: Object, Codable {
    @objc dynamic var details: String = ""
    @objc dynamic var eventId: Int = 0
    @objc dynamic var formalId: String = ""
    @objc dynamic var gameId: String = ""
    @objc dynamic var period: Int = 0 //TODO: make enum of 1, 2, 3, ot(int)
    @objc dynamic var strength: Int = 0 //TODO: make enum or change api to return enum
    @objc dynamic var teamId: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var type: String = "" //TODO: make enum
    @objc dynamic var videoLink: String = ""

    enum CodingKeys: String, CodingKey {
        case details = "description"
        case eventId = "eventID"
        case formalId = "formalID"
        case gameId = "gameID"
        case period
        case strength
        case teamId = "teamID"
        case time
        case type
        case videoLink
    }
}
