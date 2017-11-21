import UIKit

class MatchupGameCell: UITableViewCell, Reusable {
    static var reuseIdentifier: String = "MatchupCell"

    private let content: MatchupGameView

    var game: Game {
        didSet {
            content.game = game
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        game = Game()
        content = MatchupGameView()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(content)

        content.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
