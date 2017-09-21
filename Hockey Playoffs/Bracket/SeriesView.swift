import UIKit

class SeriesView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false;
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 60, height: 55)
    }
}

enum BracketOrientation {
    case top
    case bottom
}

class BracketSectionView: UIView {
    
    let lineWidth: CGFloat = 2.0
    
    init(orientation: BracketOrientation) {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false;
                
        let topLeading = UIView()
        topLeading.translatesAutoresizingMaskIntoConstraints = false;
        topLeading.backgroundColor = UIColor.white

        let topTrailing = UIView()
        topTrailing.translatesAutoresizingMaskIntoConstraints = false;
        topTrailing.backgroundColor = UIColor.white

        let bottomMiddle = UIView()
        bottomMiddle.translatesAutoresizingMaskIntoConstraints = false;
        bottomMiddle.backgroundColor = UIColor.white

        let horizontalMiddle = UIView()
        horizontalMiddle.translatesAutoresizingMaskIntoConstraints = false;
        horizontalMiddle.backgroundColor = UIColor.white

        addSubview(topLeading)
        addSubview(topTrailing)
        addSubview(bottomMiddle)
        addSubview(horizontalMiddle)

        topLeading
            .leadingAnchor
            .constraint(equalTo: leadingAnchor)
            .isActive = true

        topLeading
            .widthAnchor
            .constraint(equalToConstant: lineWidth)
            .isActive = true

        switch orientation {
        case .top:
            topLeading
                .topAnchor
                .constraint(equalTo: topAnchor)
                .isActive = true
        case .bottom:
            topLeading
                .bottomAnchor
                .constraint(equalTo: bottomAnchor)
                .isActive = true
        }

        topLeading
            .heightAnchor
            .constraint(equalTo: heightAnchor, multiplier: 0.5)
            .isActive = true
        
        topTrailing
            .trailingAnchor
            .constraint(equalTo: trailingAnchor)
            .isActive = true
        
        topTrailing
            .widthAnchor
            .constraint(equalToConstant: lineWidth)
            .isActive = true
        
        switch orientation {
        case .top:
            topTrailing
                .topAnchor
                .constraint(equalTo: topAnchor)
                .isActive = true
        case .bottom:
            topTrailing
                .bottomAnchor
                .constraint(equalTo: bottomAnchor)
                .isActive = true
        }
        
        topTrailing
            .heightAnchor
            .constraint(equalTo: heightAnchor, multiplier: 0.5)
            .isActive = true
        
        bottomMiddle
            .centerXAnchor
            .constraint(equalTo: centerXAnchor)
            .isActive = true
        
        bottomMiddle
            .widthAnchor
            .constraint(equalToConstant: lineWidth)
            .isActive = true
        
        switch orientation {
        case .top:
            bottomMiddle
                .bottomAnchor
                .constraint(equalTo: bottomAnchor)
                .isActive = true
        case .bottom:
            bottomMiddle
                .topAnchor
                .constraint(equalTo: topAnchor)
                .isActive = true
        }
        
        bottomMiddle
            .heightAnchor
            .constraint(equalTo: heightAnchor, multiplier: 0.5)
            .isActive = true
        
        horizontalMiddle
            .leadingAnchor
            .constraint(equalTo: leadingAnchor)
            .isActive = true
        
        horizontalMiddle
            .trailingAnchor
            .constraint(equalTo: trailingAnchor)
            .isActive = true
        
        horizontalMiddle
            .centerYAnchor
            .constraint(equalTo: centerYAnchor)
            .isActive = true
        
        horizontalMiddle
            .heightAnchor
            .constraint(equalToConstant: lineWidth)
            .isActive = true
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(orientation: .top)
    }
}
