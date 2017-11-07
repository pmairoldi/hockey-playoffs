//TODO: make series a type that can't be more than the actual values

enum Series {
    case quarterFinals(seed: Int)
    case semiFinals(seed: Int)
    case conferenceFinals(seed: Int)
    case final

    init(round: Int, seed: Int) {
        switch (round, seed) {
        case (1, 1...8):
            self = .quarterFinals(seed: seed)
        case (2, 1...4):
            self = .semiFinals(seed: seed)
        case (3, 1...2):
            self = .conferenceFinals(seed: seed)
        case (4, _):
            self = .final
        default:
            fatalError("round data is invalid")
        }
    }

    var title: String {
        switch self {
        case .quarterFinals:
            return "Round 1"
        case .semiFinals:
            return "Round 2"
        case .conferenceFinals:
            return "Conference Final"
        case .final:
            return "Final"
        }
    }
}

extension Series: Hashable {
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

    static func == (lhs: Series, rhs: Series) -> Bool {
        switch (lhs, rhs) {
        case (.quarterFinals(let lhs), .quarterFinals(let rhs)):
            return lhs == rhs
        case (.semiFinals(let lhs), .semiFinals(let rhs)):
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
