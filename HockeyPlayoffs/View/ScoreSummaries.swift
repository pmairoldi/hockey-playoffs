import UIKit

// Numeric columns stay equal and compress on narrow screens. Series grids keep
// the mockup's team-column proportion; game grids give spare space to the team.
final class ScoreGrid: ProgrammaticView {
    let teamLabel: UILabel
    private(set) var numbers: [UILabel] = []
    private let teamBackground = UIView()
    private var constraintsForColumns: [NSLayoutConstraint] = []
    private var numericWidths: [NSLayoutConstraint] = []
    private var columnGaps: [NSLayoutConstraint] = []
    private let teamMinimum: CGFloat
    private let teamInset: CGFloat
    private let teamFraction: CGFloat?
    private let heading: Bool
    private var count = 0

    init(
        columns: Int, teamMinimum: CGFloat = 80, teamInset: CGFloat = 0, teamFraction: CGFloat? = nil,
        heading: Bool = false
    ) {
        self.teamMinimum = teamMinimum
        self.teamInset = teamInset
        self.teamFraction = teamFraction
        self.heading = heading
        teamLabel = label(
            style: heading ? .caption1 : .subheadline,
            color: heading ? Colors.periodScoreViewHeaderFontColor() : Colors.seriesTeamNameColor(),
            alignment: teamInset > 0 ? .left : .center)
        super.init(frame: .zero)
        backgroundColor = heading ? .clear : Colors.periodScoreSeperatorColor()
        addForLayout(teamBackground)
        teamBackground.addForLayout(teamLabel)
        setColumnCount(columns)
        registerForTraitChanges([UITraitPreferredContentSizeCategory.self, UITraitDisplayScale.self]) {
            (view: ScoreGrid, _: UITraitCollection) in view.updateWidths()
        }
    }
    required init?(coder: NSCoder) { fatalError("Programmatic view") }
    func setColumnCount(_ newCount: Int) {
        guard newCount != count else { return }
        NSLayoutConstraint.deactivate(constraintsForColumns)
        for number in numbers { number.removeFromSuperview() }
        numbers = (0..<newCount).map { _ in
            label(
                style: heading ? .caption1 : .subheadline,
                color: heading ? Colors.periodScoreViewHeaderFontColor() : Colors.seriesTeamNameColor())
        }
        count = newCount
        for number in numbers {
            addForLayout(number)
            number.minimumScaleFactor = 0.5
        }
        var c = [
            teamBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            teamLabel.leadingAnchor.constraint(equalTo: teamBackground.leadingAnchor, constant: teamInset),
            teamLabel.trailingAnchor.constraint(equalTo: teamBackground.trailingAnchor, constant: -teamInset),
            teamLabel.topAnchor.constraint(equalTo: teamBackground.topAnchor),
            teamLabel.bottomAnchor.constraint(equalTo: teamBackground.bottomAnchor),
        ]
        numericWidths = []
        columnGaps = []
        var previous: NSLayoutXAxisAnchor = teamBackground.trailingAnchor
        for number in numbers {
            let width = number.widthAnchor.constraint(equalToConstant: 44)
            let gap = number.leadingAnchor.constraint(equalTo: previous, constant: pixel)
            numericWidths.append(width)
            columnGaps.append(gap)
            c += [gap, width]
            previous = number.trailingAnchor
        }
        c += [previous.constraint(equalTo: trailingAnchor)]
        for view in [teamBackground] + numbers {
            c += [view.topAnchor.constraint(equalTo: topAnchor), view.bottomAnchor.constraint(equalTo: bottomAnchor)]
        }
        constraintsForColumns = c
        NSLayoutConstraint.activate(c)
        setNeedsLayout()
    }
    override func layoutSubviews() {
        updateWidths()
        super.layoutSubviews()
    }
    private func updateWidths() {
        let scale = max(traitCollection.displayScale, 1)
        let metrics = UIFontMetrics(forTextStyle: .subheadline)
        let usable = max(0, round(bounds.width * scale) - CGFloat(count))
        let minimum = min(
            floor(usable * 0.42), ceil(metrics.scaledValue(for: teamMinimum, compatibleWith: traitCollection) * scale))
        let reservedForTeam = max(minimum, usable * (teamFraction ?? 0))
        let fitted = floor((usable - reservedForTeam) / CGFloat(max(1, count)))
        let preferred = round(metrics.scaledValue(for: 44, compatibleWith: traitCollection) * scale)
        let width = (teamFraction == nil ? min(preferred, fitted) : fitted) / scale
        for constraint in numericWidths where constraint.constant != width { constraint.constant = width }
        for constraint in columnGaps where constraint.constant != pixel { constraint.constant = pixel }
    }
    func setTeam(_ text: String, color: UIColor) {
        teamLabel.text = text
        teamBackground.backgroundColor = color
    }
}

final class SeriesHeader: UITableViewHeaderFooterView {
    private let caption = label(style: .caption2, color: Colors.periodScoreViewHeaderFontColor(), alignment: .left)
    private let outcome = label(style: .headline, color: Colors.gameDetailCellTextColor(), alignment: .left)
    private let headings = ScoreGrid(columns: 7, teamMinimum: 96, teamInset: 10, teamFraction: 0.29, heading: true)
    private let top = ScoreGrid(columns: 7, teamMinimum: 96, teamInset: 10, teamFraction: 0.29)
    private let bottom = ScoreGrid(columns: 7, teamMinimum: 96, teamInset: 10, teamFraction: 0.29)
    private let scores = UIView()
    private var rowHeight: NSLayoutConstraint!
    private var headingHeight: NSLayoutConstraint!
    private var rowGap: NSLayoutConstraint!

    private static var outcomeFont: UIFont {
        UIFontMetrics(forTextStyle: .headline).scaledFont(for: .systemFont(ofSize: 18, weight: .semibold))
    }
    static var estimatedHeight: CGFloat {
        ceil(
            32 + UIFont.preferredFont(forTextStyle: .caption2).lineHeight + 3 + outcomeFont.lineHeight
                + 14 + scaled(24, style: .caption1) + 2 * scaled(40) + 1)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundConfiguration = .clear()
        contentView.backgroundColor = Colors.gameBackgroundColor()
        contentView.layer.cornerRadius = 24
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = true
        caption.text = localized("series.summary.title").uppercased()
        caption.accessibilityLabel = localized("series.summary.title")
        outcome.numberOfLines = 0
        outcome.adjustsFontSizeToFitWidth = false
        outcome.accessibilityTraits.insert(.header)
        headings.teamLabel.text = localized("series.summary.team")
        for (index, text) in headings.numbers.enumerated() {
            text.text = String.localizedStringWithFormat(localized("series.summary.game.column"), index + 1)
            text.accessibilityLabel = String.localizedStringWithFormat(
                localized("series.summary.game.accessibility"), index + 1)
        }
        // Only the grid's perimeter is rounded. Its cells share straight edges.
        scores.backgroundColor = Colors.seriesHeaderBackgroundColor()
        scores.layer.cornerRadius = 8  // 24-point outer corners minus the 16-point inset.
        scores.layer.cornerCurve = .continuous
        scores.clipsToBounds = true
        contentView.addForLayout(caption, outcome, headings, scores)
        scores.addForLayout(top, bottom)
        rowHeight = top.heightAnchor.constraint(equalToConstant: scaled(40))
        headingHeight = headings.heightAnchor.constraint(equalToConstant: scaled(24, style: .caption1))
        rowGap = bottom.topAnchor.constraint(equalTo: top.bottomAnchor, constant: pixel)
        var constraints: [NSLayoutConstraint] = [
            caption.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            outcome.topAnchor.constraint(equalTo: caption.bottomAnchor, constant: 3),
            headings.topAnchor.constraint(equalTo: outcome.bottomAnchor, constant: 14),
            headingHeight,
            scores.topAnchor.constraint(equalTo: headings.bottomAnchor),
            scores.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            top.topAnchor.constraint(equalTo: scores.topAnchor),
            rowHeight,
            rowGap,
            bottom.heightAnchor.constraint(equalTo: top.heightAnchor),
            bottom.bottomAnchor.constraint(equalTo: scores.bottomAnchor),
        ]
        for view in [caption, outcome, headings, scores] {
            constraints += [
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ]
        }
        for view in [top, bottom] {
            constraints += [
                view.leadingAnchor.constraint(equalTo: scores.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: scores.trailingAnchor),
            ]
        }
        NSLayoutConstraint.activate(constraints)
        updateMetrics()
        registerForTraitChanges([UITraitPreferredContentSizeCategory.self, UITraitDisplayScale.self]) {
            (header: SeriesHeader, _: UITraitCollection) in header.updateMetrics()
        }
    }
    required init?(coder: NSCoder) { fatalError("Programmatic header") }
    private func updateMetrics() {
        outcome.font = Self.outcomeFont
        rowHeight.constant = scaled(40)
        headingHeight.constant = scaled(24, style: .caption1)
        rowGap.constant = pixel
        let teamFont = UIFontMetrics(forTextStyle: .subheadline).scaledFont(
            for: .systemFont(ofSize: 15, weight: .semibold))
        top.teamLabel.font = teamFont
        bottom.teamLabel.font = teamFont
    }
    func setSeries(_ model: SeriesModel) {
        updateMetrics()
        outcome.text = model.series.summaryTitle
        for (grid, team) in [(top, model.series.topTeam), (bottom, model.series.bottomTeam)] {
            grid.setTeam(team.isEmpty ? "—" : team.uppercased(), color: TeamHandler.getTeamColor(team))
            let teamName = team.isEmpty ? localized("series.summary.unknownTeam") : team.uppercased()
            grid.teamLabel.accessibilityLabel = teamName
            for (index, text) in grid.numbers.enumerated() {
                // Match the actual game number, not its position in a possibly
                // incomplete schedule. Missing or unplayed games show a dash.
                let game = model.games.first { Int($0.gameID.suffix(1)) == index + 1 }
                let hasScore = !team.isEmpty && (game?.hasStarted == true)
                let emphasized = hasScore && game?.hasWonGame(team) == true
                let value: String
                if hasScore, let game { value = String(game.getScoreForTeam(team)) } else { value = "—" }
                text.text = value
                text.textColor = Colors.seriesTeamNameColor()
                text.backgroundColor =
                    emphasized ? TeamHandler.getTeamColor(team) : Colors.seriesTeamNameBackgroundColor()
                text.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(
                    for: .monospacedDigitSystemFont(ofSize: 15, weight: emphasized ? .semibold : .regular))
                text.accessibilityLabel = String.localizedStringWithFormat(
                    localized("series.summary.score.accessibility"), teamName, index + 1,
                    hasScore ? value : localized("series.summary.unplayed"))
            }
        }
    }
}

final class GameHeader: UITableViewHeaderFooterView {
    let sectionControl = UISegmentedControl(items: [
        localized("game.section.goals"), localized("game.section.penalties"),
    ])
    private let overview = GameOverviewView()
    private let headings = ScoreGrid(columns: 5, heading: true)
    private let top = ScoreGrid(columns: 5), bottom = ScoreGrid(columns: 5)
    private let segmentBackground = UIView()
    private var overviewHeight: NSLayoutConstraint!, rowHeight: NSLayoutConstraint!, headingHeight: NSLayoutConstraint!
    private var rowGap: NSLayoutConstraint!
    var videoButton: VideoButton { overview.videoButton }
    private static var controlHeight: CGFloat { max(44, scaled(36, style: .body)) }
    static var height: CGFloat {
        ceil(GameOverviewView.height + scaled(20, style: .caption1) + 2 * scaled(32) + controlHeight + 25)
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Colors.gameBackgroundColor()
        // Match the control's pill ends plus the surrounding 12-point inset.
        contentView.layer.cornerRadius = Self.controlHeight / 2 + 12
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = true
        sectionControl.tintColor = Colors.tintColor()
        // Preserve the original control's title baseline after opting into
        // alignment-rectangle-based sizing (one physical pixel, not one point).
        for state in [UIControl.State.normal, .selected] {
            sectionControl.setTitleTextAttributes([.baselineOffset: pixel], for: state)
        }
        segmentBackground.backgroundColor = Colors.segmentBackgroundColor()
        contentView.addForLayout(overview, headings, top, bottom, segmentBackground, sectionControl)
        overviewHeight = overview.heightAnchor.constraint(equalToConstant: GameOverviewView.height)
        headingHeight = headings.heightAnchor.constraint(equalToConstant: scaled(20, style: .caption1))
        rowHeight = top.heightAnchor.constraint(equalToConstant: scaled(32))
        rowGap = bottom.topAnchor.constraint(equalTo: top.bottomAnchor, constant: pixel)
        var c: [NSLayoutConstraint] = [
            overviewHeight, headingHeight, rowHeight, overview.topAnchor.constraint(equalTo: contentView.topAnchor),
            headings.topAnchor.constraint(equalTo: overview.bottomAnchor),
            top.topAnchor.constraint(equalTo: headings.bottomAnchor),
            rowGap,
            bottom.heightAnchor.constraint(equalTo: top.heightAnchor),
            segmentBackground.topAnchor.constraint(equalTo: bottom.bottomAnchor),
            segmentBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            sectionControl.topAnchor.constraint(equalTo: segmentBackground.topAnchor, constant: 12),
            // Account for the system control's alignment rectangle so its visible
            // upper, lower, and side edges have matching 12-point insets.
            sectionControl.bottomAnchor.constraint(
                equalTo: segmentBackground.bottomAnchor,
                constant: -12 - sectionControl.alignmentRectInsets.bottom
            ),
            sectionControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            sectionControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ]
        for view in [overview, headings, top, bottom, segmentBackground] {
            c += [
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ]
        }
        NSLayoutConstraint.activate(c)
        registerForTraitChanges([UITraitPreferredContentSizeCategory.self, UITraitDisplayScale.self]) {
            (view: GameHeader, _: UITraitCollection) in view.updateHeights()
        }
    }
    required init?(coder: NSCoder) { fatalError("Programmatic header") }
    private func updateHeights() {
        contentView.layer.cornerRadius = Self.controlHeight / 2 + 12
        overviewHeight.constant = GameOverviewView.height
        headingHeight.constant = scaled(20, style: .caption1)
        rowHeight.constant = scaled(32)
        rowGap.constant = pixel
        for state in [UIControl.State.normal, .selected] {
            sectionControl.setTitleTextAttributes([.baselineOffset: pixel], for: state)
        }
    }
    func setGame(_ model: GameModel) {
        updateHeights()
        overview.setGame(model.game)
        let count = model.hasOTPeriod ? 6 : 5
        headings.setColumnCount(count)
        top.setColumnCount(count)
        bottom.setColumnCount(count)
        let titles =
            [localized("SOG"), "1", "2", "3"]
            + (model.hasOTPeriod ? [model.otPeriod == 1 ? localized("OT") : "\(model.otPeriod)\(localized("OT"))"] : [])
            + [localized("T")]
        for (text, title) in zip(headings.numbers, titles) { text.text = title }
        for (grid, team, shots) in [
            (top, model.game.homeID, model.game.homeShots), (bottom, model.game.awayID, model.game.awayShots),
        ] {
            let color = TeamHandler.getTeamColor(team)
            grid.setTeam(team.uppercased(), color: color)
            let values =
                [shots] + (1...(model.hasOTPeriod ? 4 : 3)).map { model.score(for: team, period: $0) } + [
                    model.game.getScoreForTeam(team)
                ]
            for (text, value) in zip(grid.numbers, values) {
                text.text = String(value)
                text.backgroundColor = color
            }
        }
    }
}
