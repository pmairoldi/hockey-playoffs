import Foundation
import RealmSwift
import UIKit

struct Store {
    
    fileprivate let api: API
    
    init(api: API = API()) {
        self.api = api
    }
    
    func fetchBracket(completion: @escaping () -> Void) {
        api.fetchBracket { (response) in
            guard let response = response else {
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
        
            let realm = try! Realm()
            
            try! realm.write {
                realm.deleteAll()
                realm.add(response.events)
                realm.add(response.games)
                realm.add(response.periods)
                realm.add(response.teams)
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func fetchSeries(round: Round) -> Series {
        
        let realm = try! Realm()
        
        let predicate: String
        switch round {
        case .westQuarterFinals(let series):
            predicate = "round = 1 AND seed = \(series) AND conference = 'w'"
            break
        case .westSemiFinals(let series):
            predicate = "round = 2 AND seed = \(series) AND conference = 'w'"
            break
        case .westFinals:
            predicate = "round = 3 AND conference = 'w'"
            break
        case .finals:
            predicate = "round = 4"
            break
        case .eastFinals:
            predicate = "round = 3 AND conference = 'e'"
            break
        case .eastSemiFinals(let series):
            predicate = "round = 2 AND seed = \(series) AND conference = 'e'"
            break
        case .eastQuarterFinals(let series):
            predicate = "round = 1 AND seed = \(series) AND conference = 'e'"
            break
        }
        
        let teams = realm.objects(Team.self).filter(predicate)
        
        guard let team = teams.first else {
            return Series(top: nil, bottom: nil)
        }
        
        let topTeam = Teams(rawValue: team.homeID)
        let bottomTeam = Teams(rawValue: team.awayID)

        return Series(top: topTeam, bottom: bottomTeam)
    }
}
