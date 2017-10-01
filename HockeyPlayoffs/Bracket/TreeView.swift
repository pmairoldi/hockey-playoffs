import UIKit

protocol TreeViewDelegate: class {
    func didSelect(series: Round)
}

protocol TreeViewDataSource: class {
    func itemAt(series: Round) -> Matchup
}

class TreeView: UIView {

    weak var delegate: TreeViewDelegate?
    weak var dataSource: TreeViewDataSource? {
        didSet {
            reloadData()
        }
    }

    fileprivate let westQuarterFinals1: SeriesView
    fileprivate let westQuarterFinals2: SeriesView
    fileprivate let westQuarterFinals3: SeriesView
    fileprivate let westQuarterFinals4: SeriesView
    fileprivate let westSemiFinals1: SeriesView
    fileprivate let westSemiFinals2: SeriesView
    fileprivate let westFinals: SeriesView
    fileprivate let finals: SeriesView
    fileprivate let eastFinals: SeriesView
    fileprivate let eastSemiFinals1: SeriesView
    fileprivate let eastSemiFinals2: SeriesView
    fileprivate let eastQuarterFinals1: SeriesView
    fileprivate let eastQuarterFinals2: SeriesView
    fileprivate let eastQuarterFinals3: SeriesView
    fileprivate let eastQuarterFinals4: SeriesView

    fileprivate lazy var roundViews: [SeriesView] = {
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

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    init() {

        func seriesView(_ round: Round) -> SeriesView {

            let seriesView = SeriesView(round: round)
            seriesView.widthAnchor.constraint(equalToConstant: 60).isActive = true
            seriesView.heightAnchor.constraint(equalToConstant: 55).isActive = true

            return seriesView
        }

        westQuarterFinals1 = seriesView(.westQuarterFinals(series: 1))
        westQuarterFinals2 = seriesView(.westQuarterFinals(series: 2))
        westQuarterFinals3 = seriesView(.westQuarterFinals(series: 3))
        westQuarterFinals4 = seriesView(.westQuarterFinals(series: 4))
        westSemiFinals1 = seriesView(.westSemiFinals(series: 1))
        westSemiFinals2 = seriesView(.westSemiFinals(series: 2))
        westFinals = seriesView(.westFinals)
        finals = seriesView(.finals)
        eastFinals = seriesView(.eastFinals)
        eastSemiFinals1 = seriesView(.eastSemiFinals(series: 1))
        eastSemiFinals2 = seriesView(.eastSemiFinals(series: 2))
        eastQuarterFinals1 = seriesView(.eastQuarterFinals(series: 1))
        eastQuarterFinals2 = seriesView(.eastQuarterFinals(series: 2))
        eastQuarterFinals3 = seriesView(.eastQuarterFinals(series: 3))
        eastQuarterFinals4 = seriesView(.eastQuarterFinals(series: 4))

        super.init(frame: .zero)

        let westQuarterFinalRound = stackView(axis: .horizontal, views: westQuarterFinals1, westQuarterFinals2, westQuarterFinals3, westQuarterFinals4)
        let westSemiFinalRound = stackView(axis: .horizontal, views: westSemiFinals1, westSemiFinals2)
        let westFinalRound = stackView(axis: .horizontal, views: westFinals)
        let finalRound = stackView(axis: .horizontal, views: finals)
        let eastFinalRound = stackView(axis: .horizontal, views: eastFinals)
        let eastSemiFinalRound = stackView(axis: .horizontal, views: eastSemiFinals1, eastSemiFinals2)
        let eastQuarterFinalRound = stackView(axis: .horizontal, views: eastQuarterFinals1, eastQuarterFinals2, eastQuarterFinals3, eastQuarterFinals4)

        let bracket = stackView(axis: .vertical, views: westQuarterFinalRound, westSemiFinalRound, westFinalRound, finalRound, eastFinalRound, eastSemiFinalRound, eastQuarterFinalRound)

        addSubview(bracket)

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

        bracket.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bracket.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bracket.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bracket.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func reloadData() {
        guard let dataSource = dataSource else {
            return
        }

        roundViews.forEach { (view) in
            view.data = dataSource.itemAt(series: view.round)
        }
    }

    fileprivate func stackView(axis: UILayoutConstraintAxis, views: UIView...) -> UIStackView {

        let stackView = UIStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.distribution = .equalCentering
        stackView.alignment = .center

        return stackView
    }

    fileprivate func addLineBetween(firstView: UIView, secondView: UIView) {

        let bracket = BracketLine()

        addSubview(bracket)

        bracket.topAnchor.constraint(equalTo: firstView.bottomAnchor).isActive = true
        bracket.bottomAnchor.constraint(equalTo: secondView.topAnchor).isActive = true
        bracket.leadingAnchor.constraint(equalTo: firstView.leadingAnchor).isActive = true
        bracket.trailingAnchor.constraint(equalTo: firstView.trailingAnchor).isActive = true
    }

    fileprivate func addBracketBetween(leadingView: UIView, trailingView: UIView, bottomView: UIView, orientation: BracketOrientation) {

        let bracket = BracketLine(orientation: orientation)

        addSubview(bracket)

        switch orientation {
        case .top:
            bracket.topAnchor.constraint(equalTo: leadingView.bottomAnchor).isActive = true
            bracket.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        case .bottom:
            bracket.bottomAnchor.constraint(equalTo: leadingView.topAnchor).isActive = true
            bracket.topAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        }

        bracket.leadingAnchor.constraint(equalTo: leadingView.centerXAnchor).isActive = true
        bracket.trailingAnchor.constraint(equalTo: trailingView.centerXAnchor).isActive = true
        bracket.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
    }
}
