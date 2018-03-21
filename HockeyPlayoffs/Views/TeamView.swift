import UIKit

enum TeamPosition {
    case top
    case bottom
}

class TeamView: UIView {

    private let teamLabel: UILabel
    private let scoreLabel: UILabel

    var matchupTeam: MatchupTeam? {
        didSet {
            if let team = matchupTeam?.team, let wins = matchupTeam?.wins {
                backgroundColor = UIColor(hex: team.color)
                teamLabel.text = team.abbreviation.uppercased()
                scoreLabel.text = "\(wins)"
            }
        }
    }

    init(position: TeamPosition) {

        teamLabel = UILabel()
        teamLabel.textColor = .white
        teamLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        teamLabel.textAlignment = NSTextAlignment.left

        scoreLabel = UILabel()
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        scoreLabel.textAlignment = NSTextAlignment.right

        super.init(frame: .zero)

        switch position {
        case .top:
            layoutMargins = UIEdgeInsets(top: 8, left: 6, bottom: 6, right: 6)
        case .bottom:
            layoutMargins = UIEdgeInsets(top: 6, left: 6, bottom: 8, right: 6)
        }

        addSubview(teamLabel, constraints: [
            equal(\.leadingAnchor, \.layoutMarginsGuide.leadingAnchor),
            equal(\.topAnchor, \.layoutMarginsGuide.topAnchor),
            equal(\.bottomAnchor, \.layoutMarginsGuide.bottomAnchor)
            ])

        addSubview(scoreLabel, constraints: [
            equal(\.trailingAnchor, \.layoutMarginsGuide.trailingAnchor),
            equal(\.topAnchor, \.layoutMarginsGuide.topAnchor),
            equal(\.bottomAnchor, \.layoutMarginsGuide.bottomAnchor),
            equal(\.widthAnchor, to: 10),
            equal(\.leadingAnchor, teamLabel.trailingAnchor, constant: 4)
            ])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
