import UIKit

class BracketCoordinator: UINavigationController {

    convenience init(store: Store) {
        self.init(rootViewController: BracketController(store: store))

        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
        }

        title = NSLocalizedString("controller.bracket.title", comment: "bracket controller title")
        tabBarItem = UITabBarItem(title: title, image: nil, selectedImage: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
