import UIKit

protocol TreeViewDelegate: class {
    func didSelect(series: Series)
}

protocol TreeViewDataSource: class {
    func itemAt(series: Series) -> Matchup
}

class TreeView: UIView {

    weak var delegate: TreeViewDelegate?
    weak var dataSource: TreeViewDataSource? {
        didSet {
            reloadData()
        }
    }

    private let westQuarterFinals1: SeriesView
    private let westQuarterFinals2: SeriesView
    private let westQuarterFinals3: SeriesView
    private let westQuarterFinals4: SeriesView
    private let westSemiFinals1: SeriesView
    private let westSemiFinals2: SeriesView
    private let westFinals: SeriesView
    private let finals: SeriesView
    private let eastFinals: SeriesView
    private let eastSemiFinals1: SeriesView
    private let eastSemiFinals2: SeriesView
    private let eastQuarterFinals1: SeriesView
    private let eastQuarterFinals2: SeriesView
    private let eastQuarterFinals3: SeriesView
    private let eastQuarterFinals4: SeriesView

    private lazy var roundViews: [SeriesView] = {
        return [
            westQuarterFinals1,
            westQuarterFinals2,
            westQuarterFinals3,
            westQuarterFinals4,
            westSemiFinals1,
            westSemiFinals2,
            westFinals,
            finals,
            eastFinals,
            eastSemiFinals1,
            eastSemiFinals2,
            eastQuarterFinals1,
            eastQuarterFinals2,
            eastQuarterFinals3,
            eastQuarterFinals4
        ]
    }()

    init() {

        func seriesView(_ series: Series) -> SeriesView {

            let seriesView = SeriesView(series: series)
            seriesView.widthAnchor.constraint(equalToConstant: 60).isActive = true
            seriesView.heightAnchor.constraint(equalToConstant: 55).isActive = true

            return seriesView
        }

        westQuarterFinals1 = seriesView(.quarterFinals(seed: 5))
        westQuarterFinals2 = seriesView(.quarterFinals(seed: 6))
        westQuarterFinals3 = seriesView(.quarterFinals(seed: 7))
        westQuarterFinals4 = seriesView(.quarterFinals(seed: 8))
        westSemiFinals1 = seriesView(.semiFinals(seed: 3))
        westSemiFinals2 = seriesView(.semiFinals(seed: 4))
        westFinals = seriesView(.conferenceFinals(seed: 2))
        finals = seriesView(.final)
        eastFinals = seriesView(.conferenceFinals(seed: 1))
        eastSemiFinals1 = seriesView(.semiFinals(seed: 1))
        eastSemiFinals2 = seriesView(.semiFinals(seed: 2))
        eastQuarterFinals1 = seriesView(.quarterFinals(seed: 1))
        eastQuarterFinals2 = seriesView(.quarterFinals(seed: 2))
        eastQuarterFinals3 = seriesView(.quarterFinals(seed: 3))
        eastQuarterFinals4 = seriesView(.quarterFinals(seed: 4))

        super.init(frame: .zero)

        roundViews.forEach { (seriesView) in
            let touchRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectSeries))

            seriesView.addGestureRecognizer(touchRecognizer)
        }

        let westQuarterFinalRound = stackView(axis: .horizontal, views: westQuarterFinals1, westQuarterFinals2, westQuarterFinals3, westQuarterFinals4)
        let westSemiFinalRound = stackView(axis: .horizontal, views: westSemiFinals1, westSemiFinals2)
        let westFinalRound = stackView(axis: .horizontal, views: westFinals)
        let finalRound = stackView(axis: .horizontal, views: finals)
        let eastFinalRound = stackView(axis: .horizontal, views: eastFinals)
        let eastSemiFinalRound = stackView(axis: .horizontal, views: eastSemiFinals1, eastSemiFinals2)
        let eastQuarterFinalRound = stackView(axis: .horizontal, views: eastQuarterFinals1, eastQuarterFinals2, eastQuarterFinals3, eastQuarterFinals4)

        let bracket = stackView(axis: .vertical, views: westQuarterFinalRound, westSemiFinalRound, westFinalRound, finalRound, eastFinalRound, eastSemiFinalRound, eastQuarterFinalRound)

        addSubview(bracket, constraints: [
            equal(\.topAnchor),
            equal(\.leadingAnchor),
            equal(\.trailingAnchor),
            equal(\.bottomAnchor)
            ])

        addBracketBetween(leadingView: westQuarterFinals1, trailingView: westQuarterFinals2, bottomView: westSemiFinals1, orientation: .top)

        addBracketBetween(leadingView: westQuarterFinals3, trailingView: westQuarterFinals4, bottomView: westSemiFinals2, orientation: .top)

        addBracketBetween(leadingView: westSemiFinals1, trailingView: westSemiFinals2, bottomView: westFinals, orientation: .top)

        addLineBetween(firstView: westFinals, secondView: finals)

        addLineBetween(firstView: finals, secondView: eastFinals)

        addBracketBetween(leadingView: eastSemiFinals1, trailingView: eastSemiFinals2, bottomView: eastFinals, orientation: .bottom)

        addBracketBetween(leadingView: eastQuarterFinals1, trailingView: eastQuarterFinals2, bottomView: eastSemiFinals1, orientation: .bottom)

        addBracketBetween(leadingView: eastQuarterFinals3, trailingView: eastQuarterFinals4, bottomView: eastSemiFinals2, orientation: .bottom)

        westQuarterFinalRound.widthAnchor.constraint(equalTo: bracket.widthAnchor).isActive = true

        westSemiFinalRound.widthAnchor.constraint(equalTo: bracket.widthAnchor, multiplier: 0.72).isActive = true

        eastSemiFinalRound.widthAnchor.constraint(equalTo: bracket.widthAnchor, multiplier: 0.72).isActive = true

        eastQuarterFinalRound.widthAnchor.constraint(equalTo: bracket.widthAnchor).isActive = true
    }

    func reloadData() {
        guard let dataSource = dataSource else {
            return
        }

        roundViews.forEach { (view) in
            view.matchup = dataSource.itemAt(series: view.series)
        }
    }

    @objc func selectSeries(tap: UITapGestureRecognizer) {
        guard let delegate = delegate else {
            return
        }

        guard let seriesView = tap.view as? SeriesView else {
            return
        }

        delegate.didSelect(series: seriesView.series)
    }

    private func stackView(axis: UILayoutConstraintAxis, views: UIView...) -> UIStackView {

        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.distribution = .equalCentering
        stackView.alignment = .center

        return stackView
    }

    private func addLineBetween(firstView: UIView, secondView: UIView) {

        let bracket = BracketLineView()

        addSubview(bracket, constraints: [
            equal(\.topAnchor, firstView.bottomAnchor),
            equal(\.bottomAnchor, secondView.topAnchor),
            equal(\.leadingAnchor, firstView.leadingAnchor),
            equal(\.trailingAnchor, firstView.trailingAnchor)
            ])
    }

    private func addBracketBetween(leadingView: UIView, trailingView: UIView, bottomView: UIView, orientation: BracketOrientation) {

        let bracket = BracketLineView(orientation: orientation)

        let topAnchorKeyPath = { (orientation: BracketOrientation) -> NSLayoutYAxisAnchor in
            switch orientation {
            case .top:
                return leadingView.bottomAnchor
            case .bottom:
                return bottomView.bottomAnchor
            }
        }

        let bottomAnchorKeyPath = { (orientation: BracketOrientation) -> NSLayoutYAxisAnchor in
            switch orientation {
            case .top:
                return bottomView.topAnchor
            case .bottom:
                return leadingView.topAnchor
            }
        }

        addSubview(bracket, constraints: [
            equal(\.topAnchor, topAnchorKeyPath(orientation)),
            equal(\.bottomAnchor, bottomAnchorKeyPath(orientation)),
            equal(\.leadingAnchor, leadingView.centerXAnchor),
            equal(\.trailingAnchor, trailingView.centerXAnchor),
            equal(\.centerXAnchor, bottomView.centerXAnchor)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
