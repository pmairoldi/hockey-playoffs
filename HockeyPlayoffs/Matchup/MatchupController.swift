import UIKit

class MatchupController: UITableViewController {
    private let dataSource: MatchupDataSource
    private weak var delegate: MatchupDelegate?

    let store: Store
    let series: Series

    init(store: Store, series: Series) {
        self.store = store
        self.series = series

        let matchup = self.store.fetchSeries(series: series)

        self.dataSource = MatchupDataSource(games: matchup.games)
        self.delegate = MatchupDelegate()

        super.init(nibName: nil, bundle: nil)

        self.title = self.series.title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(MatchupGameCell.self, forCellReuseIdentifier: MatchupGameCell.reuseIdentifier)
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.rowHeight = UITableViewAutomaticDimension

//        dataSource = BracketDataSource(store: store)
//
//        bracketView.refreshView.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
//
//        bracketView.treeView.dataSource = dataSource
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: StoreActions.updated, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    @objc func updateData() {
//        DispatchQueue.main.async { [weak self] in
//            self?.bracketView.state = .data
//        }
    }
//
//    @objc fileprivate func refresh() {
//
//        bracketView.state = .loading
//
//        store.update()
//    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
