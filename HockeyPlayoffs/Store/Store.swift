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
        case .quarterFinals(let series):
            predicate = "roundId = 1 AND seedId = \(series)"
        case .semiFinals(let series):
            predicate = "roundId = 2 AND seedId = \(series)"
        case .conferenceFinals(let series):
            predicate = "roundId = 3 AND seedId = \(series)"
        case .final:
            predicate = "roundId = 4"
        }

        let series = realm.objects(Matchup.self).filter(predicate)

        guard let matchup = series.first else {
            return Matchup()
        }

        return matchup
    }
}
