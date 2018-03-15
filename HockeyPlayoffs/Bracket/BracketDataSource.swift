class BracketDataSource: TreeViewDataSource {

    private let store: Store

    init(store: Store) {
        self.store = store
    }

    func itemAt(series: Series) -> Matchup {
        return store.fetchSeries(series: series)
    }
}
