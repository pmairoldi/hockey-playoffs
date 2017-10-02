import UIKit

class MatchupController: UIViewController {

    let store: Store

    init(store: Store) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    var contentView: UITableView {
        return view as! UITableView
    }

    override func loadView() {
        let content = UITableView()

        view = content
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
