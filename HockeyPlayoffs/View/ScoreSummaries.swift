import UIKit

// The team column absorbs spare space. Equal, text-scaled numeric columns are
// constrained together; only their preferred width is relaxed on narrow screens.
final class ScoreGrid: ProgrammaticView {
    let teamLabel: UILabel
    private(set) var numbers: [UILabel] = []
    private let leadingFill = UIView(), trailingFill = UIView()
    private var constraintsForColumns: [NSLayoutConstraint] = []
    private var numericWidths: [NSLayoutConstraint] = []
    private var columnGaps: [NSLayoutConstraint] = []
    private let teamMinimum: CGFloat
    private let outerInset: CGFloat
    private let heading: Bool
    private var count = 0

    init(columns: Int, teamMinimum: CGFloat = 80, outerInset: CGFloat = 0, heading: Bool = false) {
        self.teamMinimum = teamMinimum
        self.outerInset = outerInset
        self.heading = heading
        teamLabel = label(
            style: heading ? .caption1 : outerInset > 0 ? .headline : .subheadline,
            color: heading ? Colors.periodScoreViewHeaderFontColor() : Colors.seriesTeamNameColor())
        super.init(frame: .zero)
        backgroundColor =
            heading
            ? .clear : outerInset > 0 ? Colors.seriesHeaderBackgroundColor() : Colors.periodScoreSeperatorColor()
        addForLayout(leadingFill, teamLabel, trailingFill)
        setColumnCount(columns)
        registerForTraitChanges([UITraitPreferredContentSizeCategory.self, UITraitDisplayScale.self]) {
            (view: ScoreGrid, _: UITraitCollection) in view.updateWidths()
        }
    }
    required init?(coder: NSCoder) { fatalError("Programmatic view") }
    func setColumnCount(_ newCount: Int) {
        guard newCount != count else { return }
        NSLayoutConstraint.deactivate(constraintsForColumns)
        numbers.forEach { $0.removeFromSuperview() }
        numbers = (0..<newCount).map { _ in
            label(
                style: heading ? .caption1 : .subheadline,
                color: heading ? Colors.periodScoreViewHeaderFontColor() : Colors.seriesTeamNameColor())
        }
        count = newCount
        for number in numbers {
            addForLayout(number)
            number.minimumScaleFactor = outerInset > 0 ? 0.6 : 0.5
        }
        var c = [
            leadingFill.leadingAnchor.constraint(equalTo: leadingAnchor),
            leadingFill.widthAnchor.constraint(equalToConstant: outerInset),
            teamLabel.leadingAnchor.constraint(equalTo: leadingFill.trailingAnchor),
            trailingFill.trailingAnchor.constraint(equalTo: trailingAnchor),
            trailingFill.widthAnchor.constraint(equalToConstant: outerInset),
        ]
        numericWidths = []
        columnGaps = []
        var previous: NSLayoutXAxisAnchor = teamLabel.trailingAnchor
        for number in numbers {
            let width = number.widthAnchor.constraint(equalToConstant: 44)
            let gap = number.leadingAnchor.constraint(equalTo: previous, constant: pixel)
            numericWidths.append(width)
            columnGaps.append(gap)
            c += [gap, width]
            previous = number.trailingAnchor
        }
        c += [trailingFill.leadingAnchor.constraint(equalTo: previous)]
        for view in [leadingFill, teamLabel, trailingFill] + numbers {
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
        let usable = max(0, round((bounds.width - 2 * outerInset) * scale) - CGFloat(count))
        let minimum = min(
            floor(usable * 0.42), ceil(metrics.scaledValue(for: teamMinimum, compatibleWith: traitCollection) * scale))
        let width =
            min(
                round(metrics.scaledValue(for: 44, compatibleWith: traitCollection) * scale),
                floor((usable - minimum) / CGFloat(max(1, count)))) / scale
        for constraint in numericWidths where constraint.constant != width { constraint.constant = width }
        for constraint in columnGaps where constraint.constant != pixel { constraint.constant = pixel }
    }
    func setTeam(_ text: String, color: UIColor) {
        teamLabel.text = text
        teamLabel.backgroundColor = color
        leadingFill.backgroundColor = color
    }
    func fillTrailingEdge() { trailingFill.backgroundColor = numbers.last?.backgroundColor }
}

final class SeriesHeader: UITableViewHeaderFooterView {
    private let top = ScoreGrid(columns: 7, teamMinimum: 104, outerInset: 16)
    private let bottom = ScoreGrid(columns: 7, teamMinimum: 104, outerInset: 16)
    private var rowGap: NSLayoutConstraint!
    static var height: CGFloat { 2 * scaled(28) + 1 }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Colors.seriesHeaderBackgroundColor()
        contentView.layer.cornerRadius = 24
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = true
        contentView.addForLayout(top, bottom)
        rowGap = bottom.topAnchor.constraint(equalTo: top.bottomAnchor, constant: pixel)
        NSLayoutConstraint.activate([
            top.topAnchor.constraint(equalTo: contentView.topAnchor),
            top.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            top.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rowGap,
            bottom.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottom.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottom.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            top.heightAnchor.constraint(equalTo: bottom.heightAnchor),
        ])
    }
    required init?(coder: NSCoder) { fatalError("Programmatic header") }
    override func layoutSubviews() {
        rowGap.constant = pixel
        super.layoutSubviews()
    }
    func setSeries(_ model: SeriesModel) {
        for (grid, team, wins) in [
            (top, model.series.topTeam, model.series.topWins),
            (bottom, model.series.bottomTeam, model.series.bottomWins),
        ] {
            grid.setTeam(team.isEmpty ? "" : "\(team.uppercased()) – \(wins)", color: TeamHandler.getTeamColor(team))
            for (index, text) in grid.numbers.enumerated() {
                let game = model.games.indices.contains(index) ? model.games[index] : nil
                text.text = game.map { String($0.getScoreForTeam(team)) } ?? ""
                text.textColor = Colors.seriesTeamNameColor()
                text.backgroundColor =
                    game?.hasWonGame(team) == true
                    ? TeamHandler.getTeamColor(team) : Colors.seriesTeamNameBackgroundColor()
            }
            grid.fillTrailingEdge()
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
    static var height: CGFloat {
        ceil(
            GameOverviewView.height + scaled(18, style: .caption1) + 2 * scaled(25) + max(44, scaled(36, style: .body))
                + 13)
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Colors.gameBackgroundColor()
        contentView.layer.cornerRadius = 24
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
        headingHeight = headings.heightAnchor.constraint(equalToConstant: scaled(18, style: .caption1))
        rowHeight = top.heightAnchor.constraint(equalToConstant: scaled(25))
        rowGap = bottom.topAnchor.constraint(equalTo: top.bottomAnchor, constant: pixel)
        var c: [NSLayoutConstraint] = [
            overviewHeight, headingHeight, rowHeight, overview.topAnchor.constraint(equalTo: contentView.topAnchor),
            headings.topAnchor.constraint(equalTo: overview.bottomAnchor),
            top.topAnchor.constraint(equalTo: headings.bottomAnchor),
            rowGap,
            bottom.heightAnchor.constraint(equalTo: top.heightAnchor),
            segmentBackground.topAnchor.constraint(equalTo: bottom.bottomAnchor),
            segmentBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            sectionControl.topAnchor.constraint(equalTo: segmentBackground.topAnchor, constant: 6),
            // Anchors use the alignment rectangle; preserve the original visible
            // 6-point inset including UIKit's extra lower control edge.
            sectionControl.bottomAnchor.constraint(
                equalTo: segmentBackground.bottomAnchor,
                constant: -6 - sectionControl.alignmentRectInsets.bottom
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
        overviewHeight.constant = GameOverviewView.height
        headingHeight.constant = scaled(18, style: .caption1)
        rowHeight.constant = scaled(25)
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
