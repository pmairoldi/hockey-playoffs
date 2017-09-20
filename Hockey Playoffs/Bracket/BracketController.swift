import UIKit

class BracketController: UIViewController {
    
    let bracketView: BracketView

    init() {
        
        bracketView = BracketView()
        bracketView.translatesAutoresizingMaskIntoConstraints = false;
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
        
        view.addSubview(bracketView)
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupConstraints() {
        
        let margins = view.layoutMarginsGuide;
        
        bracketView
            .leadingAnchor
            .constraint(equalTo: margins.leadingAnchor)
            .isActive = true;
        
        bracketView
            .trailingAnchor
            .constraint(equalTo: margins.trailingAnchor)
            .isActive = true;
        
        bracketView
            .topAnchor
            .constraint(equalTo: margins.topAnchor)
            .isActive = true;
        
        bracketView
            .bottomAnchor
            .constraint(equalTo: margins.bottomAnchor)
            .isActive = true;
    }
}
