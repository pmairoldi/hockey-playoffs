import UIKit

class GameSummaryView: UIView {

    private let avatarSize: CGFloat = 50.0

    private let awayTeamAvatar: TeamAvatar
    private let awayTeamLabel: UILabel
    private let awayScore: UILabel
    private let homeTeamAvatar: TeamAvatar
    private let homeTeamLabel: UILabel
    private let homeScore: UILabel

    var game: Game? {
        didSet {
            if let game = game {
                print(game)
                awayTeamAvatar.team = game.awayTeam?.team
                awayScore.text = "\(game.awayTeam?.score ?? 0)"
                homeTeamAvatar.team = game.homeTeam?.team
                homeScore.text = "\(game.homeTeam?.score ?? 0)"
            }
        }
    }

    init() {
        awayTeamAvatar = TeamAvatar(ofSize: .large)
        awayTeamLabel = GameSummaryView.teamLabel()
        awayScore = GameSummaryView.scoreLabel()
        homeTeamAvatar = TeamAvatar(ofSize: .large)
        homeTeamLabel = GameSummaryView.teamLabel()
        homeScore = GameSummaryView.scoreLabel()

        super.init(frame: .zero)

        addSubview(awayTeamAvatar, constraints: [
            equal(\.topAnchor, constant: 8.0),
            equal(\.leadingAnchor, constant: 8.0),
            equal(\.widthAnchor, to: avatarSize),
            equal(\.heightAnchor, to: avatarSize)
            ])

        addSubview(awayTeamLabel, constraints: [
            equal(\.topAnchor, awayTeamAvatar.bottomAnchor, constant: 4.0),
            equal(\.leadingAnchor, awayTeamAvatar.leadingAnchor)
            ])

        addSubview(awayScore, constraints: [
            equal(\.topAnchor, awayTeamAvatar.topAnchor),
            equal(\.bottomAnchor, awayTeamAvatar.bottomAnchor),
            equal(\.leadingAnchor, awayTeamAvatar.trailingAnchor, constant: 4.0)
            ])

        addSubview(homeTeamAvatar, constraints: [
            equal(\.topAnchor, constant: 8.0),
            equal(\.trailingAnchor, constant: -8.0),
            equal(\.widthAnchor, to: avatarSize),
            equal(\.heightAnchor, to: avatarSize)
            ])

        addSubview(homeTeamLabel, constraints: [
            equal(\.topAnchor, homeTeamAvatar.bottomAnchor, constant: 4.0),
            equal(\.leadingAnchor, homeTeamAvatar.leadingAnchor)
            ])

        addSubview(homeScore, constraints: [
            equal(\.topAnchor, homeTeamAvatar.topAnchor),
            equal(\.bottomAnchor, homeTeamAvatar.bottomAnchor),
            equal(\.trailingAnchor, homeTeamAvatar.leadingAnchor, constant: -4.0)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func scoreLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .gameCellScore
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignBaselines

        return label
    }

    private static func statusLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .gameCellStatusText
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byWordWrapping

        return label

    }

    private static func teamLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .gameCellTeamText
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byWordWrapping

        return label
    }

    private static func gameLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .gameLabelText
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters

        return label

    }
}
