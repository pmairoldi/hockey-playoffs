import UIKit

class MatchupGameView: UIView {

    private let homeTeam: UILabel
    private let awayTeam: UILabel

    var game: Game {
        didSet {
            homeTeam.text = game.homeId
            awayTeam.text = game.awayId
        }
    }

    init() {
        game = Game()

        homeTeam = UILabel()
        homeTeam.translatesAutoresizingMaskIntoConstraints = false

        awayTeam = UILabel()
        awayTeam.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        addSubview(homeTeam, constraints: [
            equal(\.topAnchor, constant: 8.0),
            equal(\.bottomAnchor, constant: 8.0),
            equal(\.leadingAnchor, constant: 8.0),
            equal(\.trailingAnchor, \.centerXAnchor)
        ])

        addSubview(awayTeam, constraints: [
            equal(\.topAnchor, constant: 8.0),
            equal(\.bottomAnchor, constant: 8.0),
            equal(\.trailingAnchor, constant: 8.0),
            equal(\.leadingAnchor, \.centerXAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
