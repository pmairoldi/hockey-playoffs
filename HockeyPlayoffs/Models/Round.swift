//TODO: make series a type that can't be more than the actual values

enum Round {
    case quarterFinals(series: Int)
    case semiFinals(series: Int)
    case conferenceFinals(series: Int)
    case final

    init(round: Int, series: Int) {
        switch (round, series) {
        case (1, 1...8):
            self = .quarterFinals(series: series)
        case (2, 1...4):
            self = .semiFinals(series: series)
        case (3, 1...2):
            self = .conferenceFinals(series: series)
        case (4, _):
            self = .final
        default:
            fatalError("round data is invalid")
        }
    }
}

extension Round: Hashable {
    var hashValue: Int {
        switch self {
        case .quarterFinals(let series):
            return 1.hashValue ^ series.hashValue
        case .semiFinals(let series):
            return 2.hashValue ^ series.hashValue
        case .conferenceFinals(let series):
            return 3.hashValue ^ series.hashValue
        case .final:
            return 4.hashValue
        }
    }

    static func == (lhs: Round, rhs: Round) -> Bool {
        switch (lhs, rhs) {
        case (.quarterFinals(let lhs), .quarterFinals(series: let rhs)):
            return lhs == rhs
        case (.semiFinals(let lhs), .semiFinals(series: let rhs)):
            return lhs == rhs
        case (.conferenceFinals(let lhs), .conferenceFinals(let rhs)):
            return lhs == rhs
        case (.final, .final):
            return true
        default:
            return false
        }
    }
}
