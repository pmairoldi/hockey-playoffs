import UIKit

enum BracketOrientation {
    case top
    case bottom
}

class BracketLineView: UIView {

    private let lineWidth: CGFloat = 2.0

    init() {
        super.init(frame: .zero)

        let view = lineView()

        addSubview(view, constraints: [
            equal(\.widthAnchor, to: lineWidth),
            equal(\.topAnchor),
            equal(\.bottomAnchor),
            equal(\.centerXAnchor)
            ])
    }

    init(orientation: BracketOrientation) {
        super.init(frame: .zero)

        let topLeading = lineView()
        let topTrailing = lineView()
        let bottomMiddle = lineView()
        let horizontalMiddle = lineView()

        addSubview(topLeading, constraints: [
            equal(\.leadingAnchor),
            equal(\.widthAnchor, to: lineWidth),
            equal(\.heightAnchor, multiplier: 0.5),
            equal(topKeyPath(for: orientation))
            ])

        addSubview(topTrailing, constraints: [
            equal(\.trailingAnchor),
            equal(\.widthAnchor, to: lineWidth),
            equal(\.heightAnchor, multiplier: 0.5),
            equal(topKeyPath(for: orientation))
            ])

        addSubview(bottomMiddle, constraints: [
            equal(\.centerXAnchor),
            equal(\.widthAnchor, to: lineWidth),
            equal(\.heightAnchor, multiplier: 0.5),
            equal(bottomKeyPath(for: orientation))
            ])

        addSubview(horizontalMiddle, constraints: [
            equal(\.leadingAnchor),
            equal(\.trailingAnchor),
            equal(\.centerYAnchor),
            equal(\.heightAnchor, to: lineWidth)
            ])
    }

    func lineView() -> UIView {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.white

        return lineView
    }

    private func topKeyPath(for orientation: BracketOrientation) -> KeyPath<UIView, NSLayoutYAxisAnchor> {
        switch orientation {
        case .top:
            return \.topAnchor
        case .bottom:
            return \.bottomAnchor
        }
    }

    private func bottomKeyPath(for orientation: BracketOrientation) -> KeyPath<UIView, NSLayoutYAxisAnchor> {
        switch orientation {
        case .top:
            return \.bottomAnchor
        case .bottom:
            return \.topAnchor
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
