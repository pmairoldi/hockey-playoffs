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

    func fetchSeries(series: Series) -> Matchup {

        let realm = try! Realm()

        let predicate: String
        switch series {
        case .quarterFinals(let seed):
            predicate = "round = 1 AND seed = \(seed)"
        case .semiFinals(let seed):
            predicate = "round = 2 AND seed = \(seed)"
        case .conferenceFinals(let seed):
            predicate = "round = 3 AND seed = \(seed)"
        case .final:
            predicate = "round = 4"
        }

        let series = realm.objects(Matchup.self).filter(predicate)

        guard let matchup = series.first else {
            return Matchup()
        }

        return matchup
    }
}
