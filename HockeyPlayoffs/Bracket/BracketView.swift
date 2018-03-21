import UIKit

enum BracketViewState {
    case loading
    case data
}

class BracketView: UIView {

    private let scrollView: UIScrollView

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
        scrollView.alwaysBounceVertical = true

        refreshView = UIRefreshControl()
        refreshView.tintColor = UIColor.white

        treeView = TreeView()

        super.init(frame: .zero)

        backgroundColor = UIColor.darkGray
        treeView.backgroundColor = backgroundColor

        addSubview(scrollView, constraints: [
            equal(\.leadingAnchor),
            equal(\.trailingAnchor),
            equal(\.topAnchor),
            equal(\.bottomAnchor)
            ])

        scrollView.addSubview(refreshView)

        scrollView.addSubview(treeView, constraints: [
            equal(\.leadingAnchor, \.layoutMarginsGuide.leadingAnchor),
            equal(\.trailingAnchor, \.layoutMarginsGuide.trailingAnchor),
            equal(\.topAnchor),
            equal(\.heightAnchor, \.layoutMarginsGuide.heightAnchor)
            ])
    }
}
