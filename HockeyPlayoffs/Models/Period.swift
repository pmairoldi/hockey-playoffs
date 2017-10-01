import Foundation
import RealmSwift

class Period: Object, Codable {
    @objc dynamic var gameId: String = ""
    @objc dynamic var goals: Int = 0
    @objc dynamic var period: Int = 0 //TODO: make enum of 1, 2, 3, ot(Int = 0)
    @objc dynamic var shots: Int = 0
    @objc dynamic var teamId: String = ""

    enum CodingKeys: String, CodingKey {
        case gameId = "gameID"
        case goals
        case period
        case shots
        case teamId = "teamID"
    }
}
