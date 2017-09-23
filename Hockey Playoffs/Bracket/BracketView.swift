import UIKit

class BracketView: UIView {
    
    let treeView: TreeView
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init() {
        treeView = TreeView()
        treeView.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        
        let refreshView = UIRefreshControl()
        refreshView.tintColor = UIColor.white
        
        super.init(frame: .zero)
        
        refreshView.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)

        backgroundColor = UIColor.darkGray
        treeView.backgroundColor = backgroundColor
        
        addSubview(scrollView)
        scrollView.addSubview(refreshView)
        scrollView.addSubview(treeView)
        
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    
        treeView.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor).isActive = true
        treeView.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor).isActive = true
        treeView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        treeView.heightAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.heightAnchor).isActive = true
    }
    
    @objc fileprivate func refresh(sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            sender.endRefreshing()
        }
    }
}
