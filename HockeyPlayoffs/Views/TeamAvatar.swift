import UIKit

enum TeamAvatarSize {
    case small
    case medium
    case large
}

class TeamAvatar: UIView {

    private let borderWidth: CGFloat = 1.0
    private let borderColor: UIColor = .lightGray

    private let teamLabel: UILabel

    override class var layerClass: Swift.AnyClass {
            return CAShapeLayer.self
    }

    override var layer: CAShapeLayer {
        return super.layer as! CAShapeLayer
    }

    var team: Team? {
        didSet {
            if let team = team {
                layer.fillColor = UIColor(hex: team.color).cgColor
                teamLabel.text = team.abbreviation.uppercased()
            }
        }
    }

    init(ofSize size: TeamAvatarSize) {

        teamLabel = UILabel()

        super.init(frame: .zero)

        teamLabel.textColor = .white
        teamLabel.font = UIFont.systemFont(ofSize: fontSize(for: size))
        teamLabel.textAlignment = NSTextAlignment.center

        addSubview(teamLabel, constraints: [
            equal(\.topAnchor),
            equal(\.bottomAnchor),
            equal(\.leadingAnchor),
            equal(\.trailingAnchor)
            ])

        layer.fillColor = UIColor.darkGray.cgColor
        layer.lineWidth = borderWidth
        layer.strokeColor = borderColor.cgColor
    }

    private func fontSize(for size: TeamAvatarSize) -> CGFloat {
        switch size {
        case .small:
            return 9
        case .medium:
            return 14
        case .large:
            return 16
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        layer.path = generateBackgrounLayerPath(in: bounds)
    }

    private func generateBackgrounLayerPath(in rect: CGRect) -> CGPath {
        return UIBezierPath(ovalIn: rect.insetBy(dx: borderWidth, dy: borderWidth)).cgPath
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
