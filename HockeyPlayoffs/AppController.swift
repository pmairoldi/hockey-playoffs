import UIKit

class AppController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let bracket = BracketCoordinator()
        let recent = UIViewController()

        viewControllers = [bracket, recent]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
