import UIKit

class BracketController: UIViewController {

    let store = Store()
    var dataSource: BracketDataSource?

    var bracketView: BracketView {
        return view as! BracketView
    }

    override func loadView() {
        let content = BracketView()

        view = content
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = BracketDataSource(store: store)

        bracketView.refreshView.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)

        bracketView.treeView.dataSource = dataSource

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

    @objc func updateData() {
        DispatchQueue.main.async { [weak self] in
            self?.bracketView.state = .data
        }
    }

    @objc fileprivate func refresh() {

        bracketView.state = .loading

        store.update()
    }
}
