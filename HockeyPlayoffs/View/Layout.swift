import UIKit

extension UIView {
    func constrain(_ child: UIView, insets: UIEdgeInsets = .zero) {
        child.translatesAutoresizingMaskIntoConstraints = false
        addSubview(child)
        NSLayoutConstraint.activate([
            child.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            child.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            child.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            child.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
        ])
    }
    func addForLayout(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
    var pixel: CGFloat { 1 / max(traitCollection.displayScale, 1) }
}

func scaled(_ size: CGFloat, style: UIFont.TextStyle = .subheadline) -> CGFloat {
    ceil(UIFontMetrics(forTextStyle: style).scaledValue(for: size))
}

@MainActor
func label(style: UIFont.TextStyle, color: UIColor, alignment: NSTextAlignment = .center) -> UILabel {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: style)
    label.adjustsFontForContentSizeCategory = true
    label.textColor = color
    label.textAlignment = alignment
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.65
    return label
}

// UIKit owns list/collection item placement. All content inside those items uses
// anchors or stack views; drawing code below only paints vector artwork.
class ProgrammaticView: UIView {
    override init(frame: CGRect) { super.init(frame: frame) }
    required init?(coder: NSCoder) { fatalError("Programmatic view") }
}
