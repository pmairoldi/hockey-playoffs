import UIKit

class GameSummaryView: UIView {

    private let avatarSize: CGFloat = 50.0

    private let homeTeam: TeamAvatar
    private let awayTeam: TeamAvatar

    var game: Game? {
        didSet {
            if let game = game {
                homeTeam.team = game.homeTeam?.team
                awayTeam.team = game.awayTeam?.team
            }
        }
    }

    init() {
        homeTeam = TeamAvatar(ofSize: .large)
        awayTeam = TeamAvatar(ofSize: .large)

        super.init(frame: .zero)

        addSubview(homeTeam, constraints: [
            equal(\.topAnchor, constant: 8.0),
            equal(\.leadingAnchor, constant: 8.0),
            equal(\.widthAnchor, to: avatarSize),
            equal(\.heightAnchor, to: avatarSize)
            ])

        addSubview(awayTeam, constraints: [
            equal(\.topAnchor, constant: 8.0),
            equal(\.trailingAnchor, constant: -8.0),
            equal(\.widthAnchor, to: avatarSize),
            equal(\.heightAnchor, to: avatarSize)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
