import UIKit

enum TeamPosition {
    case top
    case bottom
}

class TeamView: UIView {

    fileprivate let teamLabel: UILabel
    fileprivate let scoreLabel: UILabel

    var data: MatchupTeam? {
        didSet {
            if let team = data?.team, let wins = data?.wins {
                backgroundColor = UIColor(hex: team.color)
                teamLabel.text = team.abbreviation.uppercased()
                scoreLabel.text = "\(wins)"
            }
        }
    }

    init(position: TeamPosition) {

        teamLabel = UILabel()
        teamLabel.translatesAutoresizingMaskIntoConstraints = false
        teamLabel.textColor = .white
        teamLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        teamLabel.textAlignment = NSTextAlignment.left

        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        scoreLabel.textAlignment = NSTextAlignment.right

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        switch position {
        case .top:
            layoutMargins = UIEdgeInsets(top: 8, left: 6, bottom: 6, right: 6)
        case .bottom:
            layoutMargins = UIEdgeInsets(top: 6, left: 6, bottom: 8, right: 6)
        }

        addSubview(teamLabel)
        addSubview(scoreLabel)

        teamLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        teamLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        teamLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true

        scoreLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        scoreLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        scoreLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        scoreLabel.widthAnchor.constraint(equalToConstant: 10).isActive = true

        scoreLabel.leadingAnchor.constraint(equalTo: teamLabel.trailingAnchor, constant: 4).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
