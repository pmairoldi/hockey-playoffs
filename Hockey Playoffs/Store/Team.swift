import Foundation
import RealmSwift

class Team: Object, Codable {
    @objc dynamic var awayID: String = ""
    @objc dynamic var conference: String = "" //TODO: make enum of east/west
    @objc dynamic var homeID: String = ""
    @objc dynamic var round: Int = 0 //TODO: make enum of rounds
    @objc dynamic var seasonID: String = ""
    @objc dynamic var seed: Int = 0 //TODO: make enum of all possible seeds
    
    override static func indexedProperties() -> [String] {
        return ["seasonID", "conference", "round", "seed"]
    }
}
