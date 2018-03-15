import UIKit

class MatchupGameView: UIView {

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
        homeTeam = TeamAvatar()
        awayTeam = TeamAvatar()

        super.init(frame: .zero)

        addSubview(homeTeam, constraints: [
            equal(\.topAnchor, constant: 8.0),
            equal(\.bottomAnchor, constant: -8.0),
            equal(\.leadingAnchor, constant: 8.0),
            equal(\.trailingAnchor, \.centerXAnchor, constant: -4.0)
            ])

        addSubview(awayTeam, constraints: [
            equal(\.topAnchor, constant: 8.0),
            equal(\.bottomAnchor, constant: -8.0),
            equal(\.trailingAnchor, constant: -8.0),
            equal(\.leadingAnchor, \.centerXAnchor, constant: 4.0)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
