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
            return lhs == rhs;
        case (.westSemiFinals(let lhs), .westSemiFinals(series: let rhs)):
            return lhs == rhs;
        case (.westFinals, .westFinals):
            return lhs == rhs;
        case (.finals, .finals):
            return lhs == rhs;
        case (.eastFinals, .eastFinals):
            return lhs == rhs;
        case (.eastSemiFinals(let lhs), .eastSemiFinals(let rhs)):
            return lhs == rhs;
        case (.eastQuarterFinals(let lhs), .eastQuarterFinals(let rhs)):
            return lhs == rhs;
        default:
            return false;
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
            seriesView.backgroundColor = UIColor.darkGray
            seriesView.heightAnchor.constraint(equalToConstant: 55).isActive = true
            seriesView.widthAnchor.constraint(equalToConstant: 60).isActive = true
            
            return seriesView
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
        backgroundColor = UIColor.white

        let stackView = UIStackView();
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal;
        stackView.distribution = .equalSpacing;
        stackView.alignment = .center;
        
        stackView.addArrangedSubview(series[.westQuarterFinals(series: 1)]!)
        stackView.addArrangedSubview(series[.westQuarterFinals(series: 2)]!)
        stackView.addArrangedSubview(series[.westQuarterFinals(series: 3)]!)
        stackView.addArrangedSubview(series[.westQuarterFinals(series: 4)]!)

        addSubview(stackView)
        
        stackView
            .leadingAnchor
            .constraint(equalTo: leadingAnchor)
            .isActive = true;
        
        stackView
            .trailingAnchor
            .constraint(equalTo: trailingAnchor)
            .isActive = true;
        
        stackView
            .topAnchor
            .constraint(equalTo: topAnchor)
            .isActive = true;
        
        stackView
            .heightAnchor
            .constraint(equalTo: heightAnchor, multiplier: 1/7)
            .isActive = true;
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
}
