import UIKit

class AppController: UITabBarController {

    let store = Store()

    override func viewDidLoad() {
        super.viewDidLoad()

        let bracket = BracketCoordinator(store: store)
        let recent = UIViewController()

        viewControllers = [bracket, recent]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
