//TODO: make series a type that can't be more than the actual values
enum Round {
    case westQuarterFinals(series: Int)
    case westSemiFinals(series: Int)
    case westFinals
    case finals
    case eastFinals
    case eastSemiFinals(series: Int)
    case eastQuarterFinals(series: Int)
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
