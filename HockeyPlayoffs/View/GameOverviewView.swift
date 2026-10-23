import UIKit

final class GameOverviewView: ProgrammaticView {
    let videoButton = VideoButton()
    private let gameTitle = label(style: .caption1, color: Colors.gameCellTeamTextColor(), alignment: .left)
    private let leftImage = TeamImage(), rightImage = TeamImage()
    private let leftName = label(style: .subheadline, color: Colors.gameCellTeamTextColor(), alignment: .left)
    private let rightName = label(style: .subheadline, color: Colors.gameCellTeamTextColor(), alignment: .right)
    private let leftScore = label(style: .largeTitle, color: Colors.gameCellScoreColor())
    private let rightScore = label(style: .largeTitle, color: Colors.gameCellScoreColor())
    private let status = label(style: .body, color: Colors.gameCellStatusTextColor())
    private let leftIndicator = label(style: .caption2, color: Colors.gameLabelTextColor())
    private let rightIndicator = label(style: .caption2, color: Colors.gameLabelTextColor())
    private var contentConstraints: [NSLayoutConstraint] = []
    private var isScheduled = false

    static var scoreFont: UIFont {
        UIFontMetrics(forTextStyle: .largeTitle).scaledFont(
            for: .monospacedDigitSystemFont(ofSize: 35, weight: .semibold))
    }
    private static var statusFont: UIFont {
        UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 16))
    }
    private static var titleHeight: CGFloat {
        ceil(
            UIFont.preferredFont(forTextStyle: .caption1).lineHeight
                * (UIApplication.shared.preferredContentSizeCategory.isAccessibilityCategory ? 2 : 1))
    }
    static var height: CGFloat {
        let titleSpace = titleHeight + 8
        if !UIApplication.shared.preferredContentSizeCategory.isAccessibilityCategory {
            return scaled(112, style: .body) + titleSpace
        }
        let names = UIFont.preferredFont(forTextStyle: .subheadline).lineHeight * 4
        let status = statusFont.lineHeight * 2
        return ceil(2 * (max(50, names) + scoreFont.lineHeight + 12) + status + 68 + titleSpace)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addForLayout(
            gameTitle, leftImage, rightImage, leftName, rightName, leftScore, rightScore, status, leftIndicator,
            rightIndicator,
            videoButton)
        for text in [leftName, rightName, status] { text.numberOfLines = 2 }
        // Long scheduled dates still need to fit the compact central column.
        status.minimumScaleFactor = 0.5
        gameTitle.numberOfLines = 2
        leftIndicator.numberOfLines = 0
        rightIndicator.numberOfLines = 0
        updateFonts()
        rebuildConstraints()
        registerForTraitChanges([UITraitPreferredContentSizeCategory.self]) {
            (view: GameOverviewView, _: UITraitCollection) in
            view.updateFonts()
            view.rebuildConstraints()
        }
    }
    required init?(coder: NSCoder) { fatalError("Programmatic view") }
    private func updateFonts() {
        gameTitle.font = UIFontMetrics(forTextStyle: .caption1).scaledFont(
            for: .systemFont(ofSize: 12, weight: .semibold))
        leftScore.font = Self.scoreFont
        rightScore.font = Self.scoreFont
        status.font = Self.statusFont
        let font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: .systemFont(ofSize: 14))
        leftName.font = font
        rightName.font = font
    }
    private func rebuildConstraints() {
        NSLayoutConstraint.deactivate(contentConstraints)
        var c: [NSLayoutConstraint] = [
            gameTitle.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            gameTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            gameTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            gameTitle.heightAnchor.constraint(equalToConstant: Self.titleHeight),
            videoButton.widthAnchor.constraint(equalToConstant: 44),
            videoButton.heightAnchor.constraint(equalToConstant: 44),
            videoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ]
        for image in [leftImage, rightImage] {
            c += [
                image.widthAnchor.constraint(equalToConstant: 50), image.heightAnchor.constraint(equalToConstant: 50),
            ]
        }
        let accessible = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        leftName.numberOfLines = accessible ? 0 : 2
        rightName.numberOfLines = accessible ? 0 : 2
        rightName.textAlignment = accessible ? .left : .right
        if accessible {
            var previous: NSLayoutYAxisAnchor = gameTitle.bottomAnchor
            for (image, name, score, indicator) in [
                (leftImage, leftName, leftScore, leftIndicator), (rightImage, rightName, rightScore, rightIndicator),
            ] {
                c += [
                    name.topAnchor.constraint(equalTo: previous, constant: 8),
                    name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 74),
                    name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                    name.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
                    image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                    image.centerYAnchor.constraint(equalTo: name.centerYAnchor),
                    score.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
                    score.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                    score.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -4),
                    score.heightAnchor.constraint(equalToConstant: Self.scoreFont.lineHeight),
                    indicator.leadingAnchor.constraint(equalTo: centerXAnchor),
                    indicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                    indicator.topAnchor.constraint(equalTo: score.topAnchor),
                    indicator.bottomAnchor.constraint(equalTo: score.bottomAnchor),
                ]
                if image === leftImage {
                    c += [
                        status.topAnchor.constraint(equalTo: score.bottomAnchor, constant: 8),
                        status.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                        status.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                        status.heightAnchor.constraint(equalToConstant: status.font.lineHeight * 2),
                    ]
                    previous = status.bottomAnchor
                } else {
                    previous = score.bottomAnchor
                }
            }
            c += [
                videoButton.topAnchor.constraint(greaterThanOrEqualTo: previous, constant: 8),
                videoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            ]
        } else {
            c += [
                leftImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                rightImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                status.centerXAnchor.constraint(equalTo: centerXAnchor),
                leftScore.leadingAnchor.constraint(equalTo: leftImage.trailingAnchor, constant: 4),
                rightScore.trailingAnchor.constraint(equalTo: rightImage.leadingAnchor, constant: -4),
                leftIndicator.leadingAnchor.constraint(equalTo: leftScore.trailingAnchor, constant: 4),
                leftIndicator.trailingAnchor.constraint(equalTo: status.leadingAnchor, constant: -4),
                rightIndicator.trailingAnchor.constraint(equalTo: rightScore.leadingAnchor, constant: -4),
                rightIndicator.leadingAnchor.constraint(equalTo: status.trailingAnchor, constant: 4),
            ]
            if isScheduled {
                // Upcoming games need room for the full date at the same 16-point
                // size as FINAL. Their single-digit scores need less width, and
                // there are no live strength indicators to reserve space for.
                c += [
                    status.leadingAnchor.constraint(equalTo: leftScore.trailingAnchor, constant: 8),
                    status.trailingAnchor.constraint(equalTo: rightScore.leadingAnchor, constant: -8),
                ]
            } else {
                c += [status.widthAnchor.constraint(equalToConstant: 72)]
            }
            for score in [leftScore, rightScore] {
                let preferred = score.widthAnchor.constraint(equalToConstant: isScheduled ? 28 : 40)
                preferred.priority = .defaultHigh
                let narrow = score.widthAnchor.constraint(
                    lessThanOrEqualTo: widthAnchor, multiplier: 0.5, constant: -132)
                narrow.priority = UILayoutPriority(999)
                c += [score.widthAnchor.constraint(greaterThanOrEqualToConstant: 24), preferred, narrow]
            }
            for item in [leftImage, rightImage, leftScore, rightScore, status, leftIndicator, rightIndicator] {
                c += [item.topAnchor.constraint(equalTo: gameTitle.bottomAnchor, constant: 8)]
                if !(item is TeamImage) { c += [item.heightAnchor.constraint(equalToConstant: 50)] }
            }
            c += [
                leftName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                rightName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                leftName.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -30),
                rightName.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 30),
                videoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            ]
            for name in [leftName, rightName] {
                c += [
                    name.topAnchor.constraint(equalTo: gameTitle.bottomAnchor, constant: 62),
                    name.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
                ]
            }
        }
        contentConstraints = c
        NSLayoutConstraint.activate(c)
    }
    func setGame(_ game: GameObject) {
        let scheduled = !game.hasStarted
        if scheduled != isScheduled {
            isScheduled = scheduled
            rebuildConstraints()
        }
        gameTitle.text = game.overviewTitle
        leftName.text = "\(TeamHandler.getTeamCity(game.awayID))\n\(TeamHandler.getTeamName(game.awayID))"
        rightName.text = "\(TeamHandler.getTeamCity(game.homeID))\n\(TeamHandler.getTeamName(game.homeID))"
        leftImage.setImage(game.awayID)
        rightImage.setImage(game.homeID)
        leftScore.text = String(game.awayScore)
        rightScore.text = String(game.homeScore)
        status.text = game.status
        leftIndicator.attributedText = statusText(game.awayStatus)
        rightIndicator.attributedText = statusText(game.homeStatus)
        leftIndicator.isHidden = game.awayStatus.isEmpty
        rightIndicator.isHidden = game.homeStatus.isEmpty
        videoButton.isEnabled = game.hasVideo
    }
    private func statusText(_ value: String) -> NSAttributedString {
        let text = NSMutableAttributedString()
        for status in value.uppercased().components(separatedBy: ",") {
            let value = status.trimmingCharacters(in: .whitespacesAndNewlines)
            let color =
                value == "PP"
                ? Colors.powerplayColor() : value == "EN" ? Colors.emptyNetColor() : Colors.gameLabelTextColor()
            if text.length > 0 { text.append(NSAttributedString(string: "\n")) }
            text.append(NSAttributedString(string: value, attributes: [.foregroundColor: color]))
        }
        return text
    }
}
