import UIKit

class BracketDataSource: TreeViewDataSource {

    fileprivate let store: Store

    init(store: Store) {
        self.store = store
    }

    func itemAt(series: Round) -> Series {
        return store.fetchSeries(round: series)
    }
}
