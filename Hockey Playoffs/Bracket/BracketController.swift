import UIKit

class BracketController: UIViewController {

    let store = Store()

    var bracketView: BracketView {
        return view as! BracketView
    }

    override func loadView() {
        let content = BracketView()

        view = content
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bracketView.refreshView.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        bracketView.treeView.dataSource = BracketDataSource(store: store)
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

    @objc fileprivate func refresh() {

        bracketView.state = .loading

        store.fetchBracket { [weak self] in
            self?.bracketView.state = .data
        }
    }
}
