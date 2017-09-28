import UIKit

enum BracketViewState {
    case loading
    case data
}

class BracketView: UIView {
    
    fileprivate let scrollView: UIScrollView
    
    let treeView: TreeView
    let refreshView: UIRefreshControl
    
    var state: BracketViewState {
        didSet {
            switch state {
            case .loading:
                break
            case .data:
                treeView.reloadData()
                refreshView.endRefreshing()
            }
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init() {
        
        state = .data
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        
        refreshView = UIRefreshControl()
        refreshView.tintColor = UIColor.white
        
        treeView = TreeView()
        treeView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: .zero)
        
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
}
