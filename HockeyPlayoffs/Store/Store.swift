import Foundation
import RealmSwift

struct Store {

    fileprivate let api: API
    fileprivate let realm: Realm

    init(api: API = API()) {
        self.api = api
        self.realm = try! Realm()
    }

    func update(completion: @escaping () -> Void) {
        api.fetchBracket { (bracket) in
            guard let bracket = bracket else {
                DispatchQueue.main.async {
                    completion()
                }
                return
            }

            let realm = try! Realm()

            try! realm.write {
                realm.deleteAll()
                realm.add(bracket)
            }

            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func fetchSeries(round: Round) -> Matchup {

        let predicate: String
        switch round {
        case .westQuarterFinals(let series):
            predicate = "roundId = 1 AND seedId = \(series) AND conferenceId = 'w'"
            break
        case .westSemiFinals(let series):
            predicate = "roundId = 2 AND seedId = \(series) AND conferenceId = 'w'"
            break
        case .westFinals:
            predicate = "roundId = 3 AND conferenceId = 'w'"
            break
        case .finals:
            predicate = "roundId = 4"
            break
        case .eastFinals:
            predicate = "roundId = 3 AND conferenceId = 'e'"
            break
        case .eastSemiFinals(let series):
            predicate = "roundId = 2 AND seedId = \(series) AND conferenceId = 'e'"
            break
        case .eastQuarterFinals(let series):
            predicate = "roundId = 1 AND seedId = \(series) AND conferenceId = 'e'"
            break
        }

        let series = realm.objects(Matchup.self).filter(predicate)

        guard let matchup = series.first else {
            return Matchup()
        }

        return matchup
    }
}
