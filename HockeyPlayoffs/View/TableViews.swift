import UIKit

final class GameCell: UITableViewCell {
    private let overview = GameOverviewView()
    private let rowSeparator = UIView()
    private var separatorHeight: NSLayoutConstraint!
    var videoButton: VideoButton { overview.videoButton }
    var showsBottomSeparator = false { didSet { rowSeparator.isHidden = !showsBottomSeparator } }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        contentView.constrain(overview)
        contentView.addForLayout(rowSeparator)
        rowSeparator.backgroundColor = Colors.gameSeperatorColor()
        rowSeparator.isHidden = true
        rowSeparator.isUserInteractionEnabled = false
        separatorHeight = rowSeparator.heightAnchor.constraint(equalToConstant: pixel)
        NSLayoutConstraint.activate([
            rowSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            rowSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            rowSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorHeight,
        ])
        registerForTraitChanges([UITraitDisplayScale.self]) { (cell: GameCell, _: UITraitCollection) in
            cell.separatorHeight.constant = cell.pixel
        }
    }
    required init?(coder: NSCoder) { fatalError("Programmatic cell") }
    override func updateConfiguration(using state: UICellConfigurationState) {
        var background = UIBackgroundConfiguration.listGroupedCell()
        background.backgroundColor =
            state.isSelected || state.isHighlighted
            ? Colors.gameBackgroundSelectedColor() : Colors.gameBackgroundColor()
        backgroundConfiguration = background
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected { accessibilityTraits.insert(.selected) } else { accessibilityTraits.remove(.selected) }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        next?.touchesBegan(touches, with: event)
    }
    func setGame(_ game: GameObject) {
        overview.setGame(game)
        accessibilityIdentifier = "Game-\(game.relativeGameID)"
    }
}

final class GameDetailCell: UITableViewCell {
    private let teamImage = TeamImage()
    private let timeLabel = label(style: .caption1, color: Colors.gameDetailCellTimeColor())
    private let eventLabel = label(style: .body, color: Colors.gameDetailCellTextColor(), alignment: .left)
    private var identityWidth: NSLayoutConstraint!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.gameBackgroundColor()
        contentView.backgroundColor = Colors.gameBackgroundColor()
        selectionStyle = .none
        // Unlike the compact scoreboard, event descriptions must wrap, not shrink.
        eventLabel.numberOfLines = 0
        eventLabel.adjustsFontSizeToFitWidth = false
        timeLabel.adjustsFontSizeToFitWidth = false
        let identity = UIStackView(arrangedSubviews: [teamImage, timeLabel])
        identity.axis = .vertical
        identity.alignment = .center
        identity.spacing = 4
        let row = UIStackView(arrangedSubviews: [identity, eventLabel])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 16
        contentView.addForLayout(row)
        identityWidth = identity.widthAnchor.constraint(equalToConstant: scaled(44, style: .caption1))
        NSLayoutConstraint.activate([
            teamImage.widthAnchor.constraint(equalToConstant: 32),
            teamImage.heightAnchor.constraint(equalToConstant: 32), identityWidth,
            row.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            row.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            row.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            row.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        registerForTraitChanges([UITraitPreferredContentSizeCategory.self]) {
            (view: GameDetailCell, _: UITraitCollection) in view.identityWidth.constant = scaled(44, style: .caption1)
        }
    }
    required init?(coder: NSCoder) { fatalError("Programmatic cell") }
    func setEvent(_ event: EventObject) {
        timeLabel.text = event.time
        eventLabel.text = event.details
        teamImage.setImage(event.teamID, size: 9)
    }
}

final class GameDetailHeader: UITableViewHeaderFooterView {
    static var height: CGFloat { scaled(36, style: .headline) }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundConfiguration = .clear()
    }
    required init?(coder: NSCoder) { fatalError("Programmatic header") }
    func setPeriod(_ period: String) {
        var configuration = defaultContentConfiguration()
        configuration.text = period
        configuration.textProperties.color = Colors.gameDetailHeaderTextColor()
        contentConfiguration = configuration
    }
}

final class NoDataTableViewCell: UITableViewCell {
    static var height: CGFloat { scaled(44, style: .body) }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.gameBackgroundColor()
        contentView.backgroundColor = Colors.gameBackgroundColor()
        selectionStyle = .none
        separatorInset = .zero
        textLabel?.textColor = Colors.gameCellStatusTextColor()
        textLabel?.textAlignment = .center
        textLabel?.font = .preferredFont(forTextStyle: .body)
        textLabel?.adjustsFontForContentSizeCategory = true
        textLabel?.numberOfLines = 0
        textLabel?.adjustsFontSizeToFitWidth = true
        textLabel?.lineBreakMode = .byWordWrapping
    }
    required init?(coder: NSCoder) { fatalError("Programmatic cell") }
}

final class RefreshTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Colors.gameBackgroundColor()
        selectionStyle = .none
        let activity = UIActivityIndicatorView(style: .medium)
        contentView.addForLayout(activity)
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        activity.startAnimating()
    }
    required init?(coder: NSCoder) { fatalError("Programmatic cell") }
}

class NoContentTableView: UITableView {
    private let noContentLabel = label(style: .body, color: Colors.noDataTextColor())
    var noContentText: String = "" { didSet { noContentLabel.text = noContentText } }
    var hasContent = false { didSet { backgroundView?.isHidden = hasContent } }
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        noContentLabel.numberOfLines = 0
        noContentLabel.adjustsFontSizeToFitWidth = false
        let emptyView = UIView()
        emptyView.addForLayout(noContentLabel)
        NSLayoutConstraint.activate([
            noContentLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            noContentLabel.leadingAnchor.constraint(equalTo: emptyView.layoutMarginsGuide.leadingAnchor),
            noContentLabel.trailingAnchor.constraint(equalTo: emptyView.layoutMarginsGuide.trailingAnchor),
        ])
        backgroundView = emptyView
    }
    required init?(coder: NSCoder) { fatalError("Programmatic table") }
}

final class GamesTableView: NoContentTableView {
    enum Kind { case recent, series, game }
    init(kind: Kind) {
        super.init(frame: .zero, style: .insetGrouped)
        backgroundColor = .clear
        separatorColor = Colors.gameSeperatorColor()
        separatorStyle = kind == .recent ? .none : .singleLine
        cellLayoutMarginsFollowReadableWidth = true
        if kind != .recent { sectionFooterHeight = 16 }
        noContentText = localized("series.nodata")
        register(GameCell.self, forCellReuseIdentifier: "game")
        register(GameDetailCell.self, forCellReuseIdentifier: "event")
        register(RefreshTableViewCell.self, forCellReuseIdentifier: "refresh")
        register(NoDataTableViewCell.self, forCellReuseIdentifier: "empty")
        register(SeriesHeader.self, forHeaderFooterViewReuseIdentifier: "series")
        register(GameHeader.self, forHeaderFooterViewReuseIdentifier: "game")
        register(GameDetailHeader.self, forHeaderFooterViewReuseIdentifier: "period")
    }
    required init?(coder: NSCoder) { fatalError("Programmatic table") }
}
