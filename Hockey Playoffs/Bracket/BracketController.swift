import UIKit

class BracketController: UIViewController {
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func loadView() {
        let content = BracketView()
        
        view = content
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}
