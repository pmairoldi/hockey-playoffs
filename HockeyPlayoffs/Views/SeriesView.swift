import UIKit

class SeriesView: UIView {

    private let top: TeamView
    private let bottom: TeamView

    let series: Series

    var matchup: Matchup? {
        didSet {
            top.matchupTeam = matchup?.topTeam
            bottom.matchupTeam = matchup?.bottomTeam
        }
    }

    init(series: Series) {

        self.series = series

        top = TeamView(position: .top)
        bottom = TeamView(position: .bottom)

        let seperater = UIView()
        seperater.backgroundColor = UIColor.white

        super.init(frame: .zero)

        backgroundColor = UIColor.darkGray
        clipsToBounds = true

        layer.cornerRadius = 10.0
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.white.cgColor

        addSubview(seperater, constraints: [
            equal(\.leadingAnchor),
            equal(\.trailingAnchor),
            equal(\.heightAnchor, to: 1.0),
            equal(\.centerYAnchor)
            ])

        addSubview(top, constraints: [
            equal(\.leadingAnchor),
            equal(\.trailingAnchor),
            equal(\.topAnchor),
            equal(\.bottomAnchor, seperater.topAnchor)
            ])

        addSubview(bottom, constraints: [
            equal(\.leadingAnchor),
            equal(\.trailingAnchor),
            equal(\.topAnchor, seperater.bottomAnchor),
            equal(\.bottomAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
