import Foundation
import RealmSwift

class Game: Object, Codable {
    @objc dynamic var active: Int = 0
    @objc dynamic var awayCondense: String = ""
    @objc dynamic var awayHighlight: String = ""
    @objc dynamic var awayID: String = ""
    @objc dynamic var awayScore: Int = 0
    @objc dynamic var date: String = ""
    @objc dynamic var gameID: String = ""
    @objc dynamic var homeCondense: String = ""
    @objc dynamic var homeHighlight: String = ""
    @objc dynamic var homeID: String = ""
    @objc dynamic var homeScore: Int = 0
    @objc dynamic var homeStatus: String = ""
    @objc dynamic var period: Int = 0 //TODO: make enum of 1, 2, 3, ot(Int = 0)
    @objc dynamic var periodTime: String = ""
    @objc dynamic var seasonID: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var tv: String = ""
}
