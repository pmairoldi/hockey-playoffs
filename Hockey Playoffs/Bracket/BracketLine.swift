import UIKit

enum BracketOrientation {
    case top
    case bottom
}

class BracketLine: UIView {
    
    let lineWidth: CGFloat = 2.0
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let view = lineView()
        
        addSubview(view)
        
        view.widthAnchor.constraint(equalToConstant: lineWidth).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    init(orientation: BracketOrientation) {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let topLeading = lineView()
        let topTrailing = lineView()
        let bottomMiddle = lineView()
        let horizontalMiddle = lineView()
        
        addSubview(topLeading)
        addSubview(topTrailing)
        addSubview(bottomMiddle)
        addSubview(horizontalMiddle)
        
        topLeading.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topLeading.widthAnchor.constraint(equalToConstant: lineWidth).isActive = true
        topLeading.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true

        switch orientation {
        case .top:
            topLeading.topAnchor.constraint(equalTo: topAnchor).isActive = true
        case .bottom:
            topLeading.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
        
        topTrailing.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topTrailing.widthAnchor.constraint(equalToConstant: lineWidth).isActive = true
        topTrailing.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true

        switch orientation {
        case .top:
            topTrailing.topAnchor.constraint(equalTo: topAnchor).isActive = true
        case .bottom:
            topTrailing.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
        
        bottomMiddle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bottomMiddle.widthAnchor.constraint(equalToConstant: lineWidth).isActive = true
        bottomMiddle.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true

        switch orientation {
        case .top:
            bottomMiddle.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        case .bottom:
            bottomMiddle.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }
        
        horizontalMiddle.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        horizontalMiddle.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        horizontalMiddle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        horizontalMiddle.heightAnchor.constraint(equalToConstant: lineWidth).isActive = true
    }
    
    func lineView() -> UIView {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = UIColor.white
        
        return lineView
    }
}
