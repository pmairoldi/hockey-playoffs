import Foundation
import RealmSwift

struct StoreActions {
    static let updated = Notification.Name(rawValue: "data_updated")
}

struct Store {

    fileprivate let api: API

    init(api: API = API()) {
        self.api = api
        update()
    }

    func update() {

        let completion = {
            let notification = Notification(name: StoreActions.updated)
            NotificationCenter.default.post(notification)
        }

        api.fetchBracket { (bracket) in
            guard let bracket = bracket else {
                completion()
                return
            }

            let realm = try! Realm()

            try! realm.write {
                realm.add(bracket, update: true)
            }

            completion()
        }
    }

    func fetchSeries(round: Round) -> Matchup {

        let realm = try! Realm()

        let predicate: String
        switch round {
        case .westQuarterFinals(let series):
            predicate = "roundId = 1 AND seedId = \(series) AND conferenceId = 'w'"
        case .westSemiFinals(let series):
            predicate = "roundId = 2 AND seedId = \(series) AND conferenceId = 'w'"
        case .westFinals:
            predicate = "roundId = 3 AND conferenceId = 'w'"
        case .finals:
            predicate = "roundId = 4"
        case .eastFinals:
            predicate = "roundId = 3 AND conferenceId = 'e'"
        case .eastSemiFinals(let series):
            predicate = "roundId = 2 AND seedId = \(series) AND conferenceId = 'e'"
        case .eastQuarterFinals(let series):
            predicate = "roundId = 1 AND seedId = \(series) AND conferenceId = 'e'"
        }

        let series = realm.objects(Matchup.self).filter(predicate)

        guard let matchup = series.first else {
            return Matchup()
        }

        return matchup
    }
}
