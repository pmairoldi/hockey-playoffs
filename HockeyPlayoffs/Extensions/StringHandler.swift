import Foundation

class StringHandler {
    static func compare(_ string: String, withRegex regex: String) -> Bool {
        do {
            let expression = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
            let num = expression.numberOfMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: string.count))

            return num == 1
        } catch {
            return false
        }

    }
}
