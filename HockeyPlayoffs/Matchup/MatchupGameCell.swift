import UIKit

class MatchupGameCell: UITableViewCell, Reusable {
    static var reuseIdentifier: String = "MatchupCell"

    private let content: MatchupGameView

    var game: Game? {
        didSet {
            if let game = game {
                content.game = game
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        content = MatchupGameView()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(content, constraints: [
            equal(\.topAnchor, contentView.topAnchor),
            equal(\.bottomAnchor, contentView.bottomAnchor),
            equal(\.leadingAnchor, contentView.leadingAnchor),
            equal(\.trailingAnchor, contentView.trailingAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
