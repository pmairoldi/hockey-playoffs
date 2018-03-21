import UIKit

class MatchupGameCell: UITableViewCell, Reusable {
    static var reuseIdentifier: String = "MatchupCell"

    private let content: GameSummaryView

    var game: Game? {
        didSet {
            if let game = game {
                content.game = game
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        content = GameSummaryView()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(content, constraints: [
            equal(\.topAnchor),
            equal(\.bottomAnchor),
            equal(\.leadingAnchor),
            equal(\.trailingAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
