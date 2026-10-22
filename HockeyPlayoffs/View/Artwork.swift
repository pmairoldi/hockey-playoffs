import UIKit

final class TeamImage: ProgrammaticView {
    private var team = ""
    private var textSize: CGFloat = 16
    func setImage(_ team: String, size: CGFloat = 16) {
        self.team = team
        textSize = size
        backgroundColor = .clear
        setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        defer { context.restoreGState() }
        let circle = bounds.insetBy(dx: 0.5, dy: 0.5)
        context.setFillColor(TeamHandler.getTeamColor(team).cgColor)
        context.fillEllipse(in: circle)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: textSize), .foregroundColor: UIColor.white, .paragraphStyle: style,
        ]
        let text = team.uppercased() as NSString
        let offset = (circle.height - text.size(withAttributes: attributes).height) / 2
        text.draw(in: circle.offsetBy(dx: 0, dy: offset), withAttributes: attributes)
        context.setStrokeColor(Colors.teamImageStrokeColor().cgColor)
        context.setLineWidth(0.7)
        context.strokeEllipse(in: circle)
    }
}

final class VideoButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentMode = .redraw
        accessibilityIdentifier = "Play Highlights"
        accessibilityLabel = localized("Highlights")
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (button: VideoButton, _: UITraitCollection) in
            button.setNeedsDisplay()
        }
    }
    required init?(coder: NSCoder) { fatalError("Programmatic button") }
    override var isEnabled: Bool { didSet { setNeedsDisplay() } }
    override var isSelected: Bool { didSet { setNeedsDisplay() } }
    override var isHighlighted: Bool { didSet { setNeedsDisplay() } }
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        defer { context.restoreGState() }
        let icon = CGRect(x: (bounds.width - 30) / 2, y: (bounds.height - 30) / 2, width: 30, height: 30)
        let screen = CGRect(x: icon.minX, y: icon.minY, width: 30, height: 21)
        context.addRect(screen)
        context.addRect(screen.insetBy(dx: 2, dy: 2))
        context.addRect(CGRect(x: icon.minX + 6, y: icon.minY + 24.5, width: 18, height: 2))
        context.setFillColor((isEnabled ? Colors.videoButtonEnabledColor() : Colors.videoButtonDisabledColor()).cgColor)
        context.drawPath(using: .eoFill)
    }
}
