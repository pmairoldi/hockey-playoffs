//TODO: make series a type that can't be more than the actual values

enum Round {
    case westQuarterFinals(series: Int)
    case westSemiFinals(series: Int)
    case westFinals
    case finals
    case eastFinals
    case eastSemiFinals(series: Int)
    case eastQuarterFinals(series: Int)

    init(conference: Conference?, round: Int, series: Int) {
        switch (conference, round, series) {
        case (.west?, 1, 1...4):
            self = .westQuarterFinals(series: series)
        case (.west?, 2, 1...2):
            self = .westSemiFinals(series: series)
        case (.west?, 3, _):
            self = .westFinals
        case (_, 4, _):
            self = .finals
        case (.east?, 3, _):
            self = .eastFinals
        case (.east?, 2, 1...2):
            self = .eastSemiFinals(series: series)
        case (.east?, 1, 1...4):
            self = .eastQuarterFinals(series: series)
        default:
            fatalError("round data is invalid")
        }
    }

    var seed: Int {
        switch self {
        case .westQuarterFinals(let series):
            return series + 4
        case .westSemiFinals(let series):
            return series + 2
        case .westFinals:
            return 2
        case .finals:
            return 1
        case .eastFinals:
            return 1
        case .eastSemiFinals(let series):
            return series
        case .eastQuarterFinals(let series):
            return series
        }
    }
}

extension Round: Hashable {
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

    static func == (lhs: Round, rhs: Round) -> Bool {
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
