import UIKit

class BracketController: UIViewController, TreeViewDelegate {

    let store: Store
    var dataSource: BracketDataSource?

    init(store: Store) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    var contentView: BracketView {
        return view as! BracketView
    }

    override func loadView() {
        let content = BracketView()

        view = content
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = BracketDataSource(store: store)

        contentView.refreshView.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)

        contentView.treeView.dataSource = dataSource
        contentView.treeView.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: StoreActions.updated, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func didSelect(series: Series) {
        let matchupController = MatchupController(store: store, series: series)

        navigationController?.pushViewController(matchupController, animated: true)
    }

    @objc func updateData() {
        DispatchQueue.main.async { [weak self] in
            self?.contentView.state = .data
        }
    }

    @objc private func refresh() {

        contentView.state = .loading

        store.update()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
