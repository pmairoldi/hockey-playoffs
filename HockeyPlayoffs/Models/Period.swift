import Foundation
import RealmSwift

class Period: Object, Codable {
    @objc dynamic var gameID: String = ""
    @objc dynamic var goals: Int = 0
    @objc dynamic var period: Int = 0 //TODO: make enum of 1, 2, 3, ot(Int = 0)
    @objc dynamic var shots: Int = 0
    @objc dynamic var teamID: String = ""
}
