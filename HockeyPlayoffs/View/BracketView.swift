import UIKit

// Flow layout owns item frames. Geometry here is the bracket's visualization
// policy (4 → 2 → 1 → final → 1 → 2 → 4), not manual subview layout.
final class BracketView: UICollectionView {
    private var layoutSize: CGSize = .zero
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        backgroundColor = .clear
        alwaysBounceVertical = true
        register(SeriesCell.self, forCellWithReuseIdentifier: "series")
        register(
            BracketSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "connector")
    }
    required init?(coder: NSCoder) { fatalError("Programmatic bracket") }
    override func layoutSubviews() {
        if layoutSize != bounds.size {
            layoutSize = bounds.size
            collectionViewLayout.invalidateLayout()
        }
        super.layoutSubviews()
    }
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        collectionViewLayout.invalidateLayout()
        setNeedsLayout()
    }
    func itemSize(_ section: Int) -> CGSize {
        let count = BracketModel.counts[section]
        let width = floor((bounds.width - 20 - CGFloat(count - 1) * 10) / CGFloat(count))
        let height = floor((safeAreaLayoutGuide.layoutFrame.height - 20 - 6 * 20) / 7)
        return CGSize(width: max(1, min(width, 60)), height: max(44, min(height, 55)))
    }
    func sectionInsets(_ section: Int) -> UIEdgeInsets {
        let width = itemSize(section).width
        let margin: CGFloat
        if section == 1 || section == 5 {
            let quarters = endpoints(section == 1 ? 0 : 6)
            margin = floor((quarters[0].midX + quarters[1].midX) / 2 - width / 2 - 10)
        } else if (2...4).contains(section) {
            margin = (bounds.width - 20 - width) / 2
        } else {
            margin = 0
        }
        return UIEdgeInsets(
            top: section == 0 ? 10 : 0, left: 10 + margin, bottom: section == 6 ? 10 : 0, right: 10 + margin)
    }
    func spacing(_ section: Int) -> CGFloat {
        let size = itemSize(section)
        let insets = sectionInsets(section)
        let count = CGFloat(BracketModel.counts[section])
        if section == 0 || section == 6 {
            return max(
                10,
                (bounds.width - insets.left - insets.right - count * size.width) / (count - 1) - size.width
                    / (count - 1))
        }
        if section == 1 || section == 5 {
            let q = endpoints(section == 1 ? 0 : 6)
            return max(10, (q[2].midX + q[3].midX - q[0].midX - q[1].midX) / 2 - size.width)
        }
        return 10
    }
    func headerSize(_ section: Int) -> CGSize {
        guard section > 0 else { return .zero }
        let gap = floor((safeAreaLayoutGuide.layoutFrame.height - 20 - 7 * itemSize(section).height) / 6)
        return CGSize(width: bounds.width, height: max(20, gap))
    }
    func endpoints(_ section: Int) -> [CGRect] {
        let count = BracketModel.counts[section]
        let inset = sectionInsets(section)
        let size = itemSize(section)
        let gap =
            count == 1
            ? 0
            : max(
                (bounds.width - inset.left - inset.right - CGFloat(count) * size.width) / CGFloat(count - 1),
                spacing(section))
        return (0..<count).map {
            CGRect(x: inset.left + CGFloat($0) * (size.width + gap), y: 0, width: size.width, height: size.height)
        }
    }
}

final class BracketSection: UICollectionReusableView {
    private weak var bracket: BracketView?
    private var section = 1
    func configure(bracket: BracketView, section: Int) {
        self.bracket = bracket
        self.section = section
        // Equal-sized supplementary views can be reused without a layout pass.
        // Invalidate the painted connections, not just their stored geometry.
        setNeedsLayout()
        setNeedsDisplay()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentMode = .redraw
    }
    required init?(coder: NSCoder) { fatalError("Programmatic connector") }
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        guard let bracket, let context = UIGraphicsGetCurrentContext(), section > 0 else { return }
        context.saveGState()
        defer { context.restoreGState() }
        let from = bracket.endpoints(section - 1)
        let to = bracket.endpoints(section)
        context.setStrokeColor(Colors.bracketLineColor().cgColor)
        context.setLineWidth(2)
        for endpoint in from {
            context.move(to: CGPoint(x: endpoint.midX, y: 0))
            context.addLine(to: CGPoint(x: endpoint.midX, y: bounds.midY))
        }
        for endpoint in to {
            context.move(to: CGPoint(x: endpoint.midX, y: bounds.midY))
            context.addLine(to: CGPoint(x: endpoint.midX, y: bounds.height))
        }
        let pairs = to.count >= from.count ? to : from
        for index in stride(from: 0, to: pairs.count - 1, by: 2) {
            context.move(to: CGPoint(x: pairs[index].midX - 1, y: bounds.midY))
            context.addLine(to: CGPoint(x: pairs[index + 1].midX + 1, y: bounds.midY))
        }
        context.strokePath()
    }
}

// Preserve the diagram's fixed-font baselines through Auto Layout's alignment
// rectangle API, including the original fractional-pixel text placement.
private final class BracketLabel: UILabel {
    var isBottomRow = false
    var isScore = false
    override var alignmentRectInsets: UIEdgeInsets {
        var insets = super.alignmentRectInsets
        let baselinePixels: CGFloat = isBottomRow ? 0.25 : isScore ? -0.25 : 0.75
        let offset = baselinePixels / max(traitCollection.displayScale, 1)
        insets.top -= offset
        insets.bottom += offset
        return insets
    }
}

final class SeriesCell: UICollectionViewCell {
    private let topName = BracketLabel(), bottomName = BracketLabel(), topWins = BracketLabel(),
        bottomWins = BracketLabel()
    private let activity = UIActivityIndicatorView()
    private var hasGameToday = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentMode = .redraw
        let top = UILayoutGuide()
        let bottom = UILayoutGuide()
        contentView.addLayoutGuide(top)
        contentView.addLayoutGuide(bottom)
        contentView.addForLayout(topName, bottomName, topWins, bottomWins, activity)
        var c: [NSLayoutConstraint] = [
            top.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            top.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            top.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            bottom.leadingAnchor.constraint(equalTo: top.leadingAnchor),
            bottom.trailingAnchor.constraint(equalTo: top.trailingAnchor),
            bottom.topAnchor.constraint(equalTo: top.bottomAnchor),
            bottom.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            top.heightAnchor.constraint(equalTo: bottom.heightAnchor),
            activity.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        for (guide, name, wins) in [(top, topName, topWins), (bottom, bottomName, bottomWins)] {
            name.isBottomRow = guide === bottom
            wins.isBottomRow = guide === bottom
            wins.isScore = true
            name.font = .boldSystemFont(ofSize: 14)
            name.textColor = Colors.seriesTeamNameColor()
            name.textAlignment = .left
            wins.font = .systemFont(ofSize: 15)
            wins.textColor = Colors.seriesTeamNameColor()
            wins.textAlignment = .right
            wins.setContentHuggingPriority(.required, for: .horizontal)
            c += [
                name.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 4),
                name.trailingAnchor.constraint(equalTo: wins.leadingAnchor),
                wins.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -4),
                name.topAnchor.constraint(equalTo: guide.topAnchor),
                name.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
                wins.topAnchor.constraint(equalTo: guide.topAnchor),
                wins.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            ]
        }
        NSLayoutConstraint.activate(c)
        activity.hidesWhenStopped = true
    }
    required init?(coder: NSCoder) { fatalError("Programmatic cell") }
    override var isSelected: Bool { didSet { setNeedsDisplay() } }
    override var isHighlighted: Bool { didSet { setNeedsDisplay() } }
    func setSeries(_ series: SeriesObject?, refreshing: Bool) {
        topName.text = series?.topTeam.uppercased()
        bottomName.text = series?.bottomTeam.uppercased()
        let empty = (series?.topTeam.isEmpty ?? true) || (series?.bottomTeam.isEmpty ?? true)
        topWins.text = empty ? "" : String(series!.topWins)
        bottomWins.text = empty ? "" : String(series!.bottomWins)
        hasGameToday = series?.hasGameToday ?? false
        accessibilityIdentifier = "Series-\(series?.relativeSeriesID ?? "")"
        if refreshing { activity.startAnimating() } else { activity.stopAnimating() }
        setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        defer { context.restoreGState() }
        let stroke: CGFloat = hasGameToday ? 2.5 : 2
        let border = hasGameToday ? Colors.seriesBorderTodayColor() : Colors.seriesBorderColor()
        border.setFill()
        UIBezierPath(roundedRect: bounds, cornerRadius: 10).fill()
        let inside = bounds.insetBy(dx: stroke, dy: stroke)
        (hasGameToday ? border : Colors.seriesBackgroundColor()).setFill()
        UIBezierPath(roundedRect: inside, cornerRadius: 10 - stroke).fill()
        let top = CGRect(x: inside.minX, y: inside.minY, width: inside.width, height: inside.height / 2 - 0.5)
        let bottom = CGRect(x: inside.minX, y: inside.midY + 0.5, width: inside.width, height: inside.height / 2 - 0.5)
        TeamHandler.getTeamColor(topName.text).setFill()
        UIBezierPath(
            roundedRect: top, byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 10 - stroke, height: 10 - stroke)
        ).fill()
        TeamHandler.getTeamColor(bottomName.text).setFill()
        UIBezierPath(
            roundedRect: bottom, byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: 10 - stroke, height: 10 - stroke)
        ).fill()
        if isSelected || isHighlighted {
            Colors.seriesSelectedColor().setFill()
            UIBezierPath(roundedRect: bounds, cornerRadius: 10).fill()
        }
    }
}
