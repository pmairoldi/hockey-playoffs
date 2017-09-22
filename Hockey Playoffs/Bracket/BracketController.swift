import UIKit

class BracketController: UIViewController {
    
    let bracketView: BracketView
    let scrollView: UIScrollView
    
    init() {
        
        bracketView = BracketView()
        bracketView.translatesAutoresizingMaskIntoConstraints = false;
    
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGray
        
        view.addSubview(scrollView)
        scrollView.addSubview(bracketView)
        scrollView.backgroundColor = UIColor.red
        scrollView.alwaysBounceVertical = true

        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupConstraints() {
        
        let margins = view!;
        
        scrollView
            .leadingAnchor
            .constraint(equalTo: margins.leadingAnchor)
            .isActive = true;
        
        scrollView
            .trailingAnchor
            .constraint(equalTo: margins.trailingAnchor)
            .isActive = true;
        
        scrollView
            .topAnchor
            .constraint(equalTo: margins.topAnchor)
            .isActive = true;
        
        scrollView
            .bottomAnchor
            .constraint(equalTo: margins.bottomAnchor)
            .isActive = true;
        
        bracketView
            .bottomAnchor
            .constraint(equalTo: scrollView.layoutMarginsGuide.bottomAnchor)
            .isActive = true;
        
        bracketView
            .topAnchor
            .constraint(equalTo: scrollView.layoutMarginsGuide.topAnchor)
            .isActive = true;
        
        bracketView
            .leadingAnchor
            .constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor)
            .isActive = true;
        
        bracketView
            .trailingAnchor
            .constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor)
            .isActive = true;
    }
}
