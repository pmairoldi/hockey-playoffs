import UIKit

//TODO: make series a type that can't be more than the actual values
enum BracketSection {
    case westQuarterFinals(series: Int)
    case westSemiFinals(series: Int)
    case westFinals
    case finals
    case eastFinals
    case eastSemiFinals(series: Int)
    case eastQuarterFinals(series: Int)
}

extension BracketSection: Hashable {
    var hashValue: Int {
        switch self {
        case .westQuarterFinals(let series):
            return 1.hashValue ^ series.hashValue
        case .westSemiFinals(let series):
            return 2.hashValue ^ series.hashValue
        case .westFinals:
            return 3.hashValue
        case .finals:
            return 4.hashValue
        case .eastFinals:
            return 5.hashValue
        case .eastSemiFinals(let series):
            return 6.hashValue ^ series.hashValue
        case .eastQuarterFinals(let series):
            return 7.hashValue ^ series.hashValue
        }
    }
    
    static func ==(lhs: BracketSection, rhs: BracketSection) -> Bool {
        switch (lhs, rhs) {
        case (.westQuarterFinals(let lhs), .westQuarterFinals(series: let rhs)):
            return lhs == rhs
        case (.westSemiFinals(let lhs), .westSemiFinals(series: let rhs)):
            return lhs == rhs
        case (.westFinals, .westFinals):
            return true
        case (.finals, .finals):
            return true
        case (.eastFinals, .eastFinals):
            return true
        case (.eastSemiFinals(let lhs), .eastSemiFinals(let rhs)):
            return lhs == rhs
        case (.eastQuarterFinals(let lhs), .eastQuarterFinals(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}

protocol BracketViewDelegate {
    func didSelect(series: BracketSection)
}

protocol BracketViewDataSource {
    func itemAt(series: BracketSection)
}

class BracketView: UIView {
    
    var delegate: BracketViewDelegate?
    var dataSource: BracketViewDataSource?
    
    fileprivate let series: [BracketSection: SeriesView]
    
    init() {
        
        func seriesView() -> SeriesView {
            
            let seriesView = SeriesView()
            seriesView.backgroundColor = UIColor.white

            return seriesView
        }
        
        func roundStackView(_ views: [UIView]) -> UIStackView {
            
            let stackView = UIStackView(arrangedSubviews: views)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.alignment = .center
            
            return stackView
        }
        
        series = [
            .westQuarterFinals(series: 1) : seriesView(),
            .westQuarterFinals(series: 2) : seriesView(),
            .westQuarterFinals(series: 3) : seriesView(),
            .westQuarterFinals(series: 4) : seriesView(),
            .westSemiFinals(series: 1) : seriesView(),
            .westSemiFinals(series: 2) : seriesView(),
            .westFinals : seriesView(),
            .finals : seriesView(),
            .eastFinals : seriesView(),
            .eastSemiFinals(series: 1) : seriesView(),
            .eastSemiFinals(series: 2) : seriesView(),
            .eastQuarterFinals(series: 1) : seriesView(),
            .eastQuarterFinals(series: 2) : seriesView(),
            .eastQuarterFinals(series: 3) : seriesView(),
            .eastQuarterFinals(series: 4) : seriesView()
        ]
        
        super.init(frame: CGRect.zero)
        
        let westQuarterFinals = roundStackView([
            series[.westQuarterFinals(series: 1)]!,
            series[.westQuarterFinals(series: 2)]!,
            series[.westQuarterFinals(series: 3)]!,
            series[.westQuarterFinals(series: 4)]!
            ])
        
        let westSemiFinals = roundStackView([
            series[.westSemiFinals(series: 1)]!,
            series[.westSemiFinals(series: 2)]!
            ])
        
        let westFinals = roundStackView([
            series[.westFinals]!
            ])
        
        let finals = roundStackView([
            series[.finals]!
            ])
        
        let eastFinals = roundStackView([
            series[.eastFinals]!
            ])
        
        let eastSemiFinals = roundStackView([
            series[.eastSemiFinals(series: 1)]!,
            series[.eastSemiFinals(series: 2)]!
            ])
        
        let eastQuarterFinals = roundStackView([
            series[.eastQuarterFinals(series: 1)]!,
            series[.eastQuarterFinals(series: 2)]!,
            series[.eastQuarterFinals(series: 3)]!,
            series[.eastQuarterFinals(series: 4)]!
            ])
        
        let stackView = UIStackView(arrangedSubviews: [
            westQuarterFinals,
            westSemiFinals,
            westFinals,
            finals,
            eastFinals,
            eastSemiFinals,
            eastQuarterFinals
            ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        
        let lineView = BracketSectionView(orientation: .top)
        let lineView2 = BracketSectionView(orientation: .top)
        let lineView3 = BracketSectionView(orientation: .top)
        let lineView4 = BracketSectionView(orientation: .bottom)
        let lineView5 = BracketSectionView(orientation: .bottom)
        let lineView6 = BracketSectionView(orientation: .bottom)
        let lineView7 = UIView()
        lineView7.translatesAutoresizingMaskIntoConstraints = false;
        lineView7.backgroundColor = UIColor.white
        let lineView8 = UIView()
        lineView8.translatesAutoresizingMaskIntoConstraints = false;
        lineView8.backgroundColor = UIColor.white

        addSubview(stackView)
        addSubview(lineView)
        addSubview(lineView2)
        addSubview(lineView3)
        addSubview(lineView4)
        addSubview(lineView5)
        addSubview(lineView6)
        addSubview(lineView7)
        addSubview(lineView8)
        
        lineView
            .topAnchor
            .constraint(equalTo: series[.westQuarterFinals(series: 1)]!.bottomAnchor)
            .isActive = true
        
        lineView
            .bottomAnchor
            .constraint(equalTo: series[.westSemiFinals(series: 1)]!.topAnchor)
            .isActive = true
        
        lineView
            .leadingAnchor
            .constraint(equalTo: series[.westQuarterFinals(series: 1)]!.centerXAnchor)
            .isActive = true

        lineView
            .trailingAnchor
            .constraint(equalTo: series[.westQuarterFinals(series: 2)]!.centerXAnchor)
            .isActive = true
        
        lineView2
            .topAnchor
            .constraint(equalTo: series[.westQuarterFinals(series: 3)]!.bottomAnchor)
            .isActive = true
        
        lineView2
            .bottomAnchor
            .constraint(equalTo: series[.westSemiFinals(series: 2)]!.topAnchor)
            .isActive = true
        
        lineView2
            .leadingAnchor
            .constraint(equalTo: series[.westQuarterFinals(series: 3)]!.centerXAnchor)
            .isActive = true
        
        lineView2
            .trailingAnchor
            .constraint(equalTo: series[.westQuarterFinals(series: 4)]!.centerXAnchor)
            .isActive = true
        
        lineView3
            .topAnchor
            .constraint(equalTo: series[.westSemiFinals(series: 1)]!.bottomAnchor)
            .isActive = true
        
        lineView3
            .bottomAnchor
            .constraint(equalTo: series[.westFinals]!.topAnchor)
            .isActive = true
        
        lineView3
            .leadingAnchor
            .constraint(equalTo: series[.westSemiFinals(series: 1)]!.centerXAnchor)
            .isActive = true
        
        lineView3
            .trailingAnchor
            .constraint(equalTo: series[.westSemiFinals(series: 2)]!.centerXAnchor)
            .isActive = true
        
        lineView4
            .topAnchor
            .constraint(equalTo: series[.eastFinals]!.bottomAnchor)
            .isActive = true
        
        lineView4
            .bottomAnchor
            .constraint(equalTo: series[.eastSemiFinals(series: 1)]!.topAnchor)
            .isActive = true
        
        lineView4
            .leadingAnchor
            .constraint(equalTo: series[.eastSemiFinals(series: 1)]!.centerXAnchor)
            .isActive = true
        
        lineView4
            .trailingAnchor
            .constraint(equalTo: series[.eastSemiFinals(series: 2)]!.centerXAnchor)
            .isActive = true
        
        lineView5
            .topAnchor
            .constraint(equalTo: series[.eastSemiFinals(series: 1)]!.bottomAnchor)
            .isActive = true
        
        lineView5
            .bottomAnchor
            .constraint(equalTo: series[.eastQuarterFinals(series: 1)]!.topAnchor)
            .isActive = true
        
        lineView5
            .leadingAnchor
            .constraint(equalTo: series[.eastQuarterFinals(series: 1)]!.centerXAnchor)
            .isActive = true
        
        lineView5
            .trailingAnchor
            .constraint(equalTo: series[.eastQuarterFinals(series: 2)]!.centerXAnchor)
            .isActive = true
        
        lineView6
            .topAnchor
            .constraint(equalTo: series[.eastSemiFinals(series: 2)]!.bottomAnchor)
            .isActive = true
        
        lineView6
            .bottomAnchor
            .constraint(equalTo: series[.eastQuarterFinals(series: 3)]!.topAnchor)
            .isActive = true
        
        lineView6
            .leadingAnchor
            .constraint(equalTo: series[.eastQuarterFinals(series: 3)]!.centerXAnchor)
            .isActive = true
        
        lineView6
            .trailingAnchor
            .constraint(equalTo: series[.eastQuarterFinals(series: 4)]!.centerXAnchor)
            .isActive = true
        
        lineView7
            .topAnchor
            .constraint(equalTo: series[.westFinals]!.bottomAnchor)
            .isActive = true
        
        lineView7
            .bottomAnchor
            .constraint(equalTo: series[.finals]!.topAnchor)
            .isActive = true
        
        lineView7
            .centerXAnchor
            .constraint(equalTo: series[.westFinals]!.centerXAnchor)
            .isActive = true
        
        lineView7
            .widthAnchor
            .constraint(equalToConstant: 2.0)
            .isActive = true
        
        lineView8
            .topAnchor
            .constraint(equalTo: series[.finals]!.bottomAnchor)
            .isActive = true
        
        lineView8
            .bottomAnchor
            .constraint(equalTo: series[.eastFinals]!.topAnchor)
            .isActive = true
        
        lineView8
            .centerXAnchor
            .constraint(equalTo: series[.eastFinals]!.centerXAnchor)
            .isActive = true
        
        lineView8
            .widthAnchor
            .constraint(equalToConstant: 2.0)
            .isActive = true
        
        westQuarterFinals
            .widthAnchor
            .constraint(equalTo: stackView.widthAnchor)
            .isActive = true
        
        westSemiFinals
            .widthAnchor
            .constraint(equalTo: stackView.widthAnchor, multiplier: 0.72)
            .isActive = true

        eastSemiFinals
            .widthAnchor
            .constraint(equalTo: stackView.widthAnchor, multiplier: 0.72)
            .isActive = true

        eastQuarterFinals
            .widthAnchor
            .constraint(equalTo: stackView.widthAnchor)
            .isActive = true

        stackView
            .topAnchor
            .constraint(equalTo: topAnchor)
            .isActive = true
        
        stackView
            .leadingAnchor
            .constraint(equalTo: leadingAnchor)
            .isActive = true
        
        stackView
            .trailingAnchor
            .constraint(equalTo: trailingAnchor)
            .isActive = true
        
        stackView
            .bottomAnchor
            .constraint(equalTo: bottomAnchor)
            .isActive = true
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
}
