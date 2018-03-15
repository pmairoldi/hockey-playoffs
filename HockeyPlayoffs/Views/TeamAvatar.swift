import UIKit

class TeamAvatar: UIView {

    private let teamLabel: UILabel

    var team: Team? {
        didSet {
            if let team = team {
                backgroundColor = UIColor(hex: team.color)
                teamLabel.text = team.abbreviation.uppercased()
            }
        }
    }

    init() {

        teamLabel = UILabel()
        teamLabel.textColor = .white
        teamLabel.font = UIFont.systemFont(ofSize: 14.0)
        teamLabel.textAlignment = NSTextAlignment.center

        super.init(frame: .zero)

        addSubview(teamLabel, constraints: [
            equal(\.topAnchor, \.topAnchor),
            equal(\.bottomAnchor, \.bottomAnchor),
            equal(\.leadingAnchor, \.leadingAnchor),
            equal(\.trailingAnchor, \.trailingAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
