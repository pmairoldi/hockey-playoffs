import UIKit

class AppController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let bracket = BracketCoordinator()
        let recent = UIViewController()
        
        viewControllers = [bracket, recent]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
