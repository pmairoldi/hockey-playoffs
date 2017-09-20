import UIKit

class BracketCoordinator: UINavigationController {
    
    convenience init() {
        self.init(rootViewController: BracketController())

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
