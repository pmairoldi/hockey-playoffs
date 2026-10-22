import Foundation
import UIKit

func localized(_ key: String) -> String { NSLocalizedString(key, comment: "") }

// Make formatters per operation: background database reads must not share mutable formatters.
enum FormatterHandler {
    static func formatter(_ format: String, english: Bool = false) -> DateFormatter {
        let formatter = DateFormatter()
        if english { formatter.locale = Locale(identifier: "en_US") }
        formatter.dateFormat = format
        return formatter
    }
    static func fullDateFormatter() -> DateFormatter { formatter("yyyy-MM-dd", english: true) }
    static func fullDateTimeFormatter() -> DateFormatter { formatter("yyyy-MM-dd HH:mm:ss", english: true) }
    static func longDateFormatter() -> DateFormatter { formatter("EEE, MMM d, yyyy") }
    static func timeFormatter() -> DateFormatter { formatter("h:mm a") }
}

enum StringHandler {
    static func compare(_ string: String?, withRegex regex: String?) -> Bool {
        guard let string, let regex,
            let expression = try? NSRegularExpression(pattern: regex, options: .caseInsensitive)
        else { return false }
        return expression.numberOfMatches(in: string, range: NSRange(string.startIndex..., in: string)) == 1
    }
}

enum DateTimeHandler {
    static func now() -> Date {
        #if DEBUG
            if UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT"),
                let value = UserDefaults.standard.string(forKey: "date"),
                let date = FormatterHandler.fullDateTimeFormatter().date(from: value)
            {
                return date
            }
        #endif
        return Date()
    }
    static func getDateForDate(_ date: String?, andTime time: String?) -> String {
        guard StringHandler.compare(date, withRegex: "\\d{4}-\\d{2}-\\d{2}"), date != "9999-12-31",
            let converted = convert(date, time)
        else { return "" }
        return FormatterHandler.longDateFormatter().string(from: converted)
    }
    static func getTimeForDate(_ date: String?, andTime time: String?) -> String {
        guard StringHandler.compare(time, withRegex: "\\d{2}:\\d{2}:\\d{2}"), let converted = convert(date, time) else {
            return localized("time.tbd")
        }
        return FormatterHandler.timeFormatter().string(from: converted)
    }
    static func getStringFor(_ date: Date?) -> String {
        guard let date else { return "" }
        let offset =
            TimeZone(abbreviation: "EST")!.secondsFromGMT(for: date) - NSTimeZone.default.secondsFromGMT(for: date)
        return FormatterHandler.fullDateFormatter().string(from: date.addingTimeInterval(Double(offset)))
    }
    private static func convert(_ date: String?, _ time: String?) -> Date? {
        let date = date.flatMap { $0.isEmpty ? nil : $0 } ?? "1970-01-01"
        let time = time.flatMap { $0.isEmpty ? nil : $0 } ?? "00:00:00"
        guard let source = FormatterHandler.fullDateTimeFormatter().date(from: "\(date) \(time)") else { return nil }
        let offset =
            NSTimeZone.default.secondsFromGMT(for: source) - TimeZone(abbreviation: "EST")!.secondsFromGMT(for: source)
        return source.addingTimeInterval(Double(offset))
    }
}

extension Dictionary where Key == String, Value == Any {
    func string(_ key: String) -> String { self[key] as? String ?? "" }
    func integer(_ key: String) -> Int {
        if let number = self[key] as? NSNumber { return number.intValue }
        return Int(self[key] as? String ?? "") ?? 0
    }
}

enum TeamHandler {
    private static var teams: [String: [String: Any]] {
        guard let url = Bundle.main.url(forResource: "teams", withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else { return [:] }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: [String: Any]] ?? [:]
    }
    static func getTeamCity(_ abbreviation: String?) -> String {
        teams[abbreviation?.lowercased() ?? ""]?.string("city").capitalized ?? ""
    }
    static func getTeamName(_ abbreviation: String?) -> String {
        teams[abbreviation?.lowercased() ?? ""]?.string("name").capitalized ?? ""
    }
    static func getTeamColor(_ abbreviation: String?) -> UIColor {
        guard let abbreviation, abbreviation.count >= 3,
            let color = teams[String(abbreviation.prefix(3)).lowercased()]?["color"] as? [String: Any]
        else { return Colors.blankTeamColor() }
        let r = color.integer("red")
        let g = color.integer("green")
        let b = color.integer("blue")
        guard r != 0 || g != 0 || b != 0 else { return Colors.blankTeamColor() }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
    }
}

extension Notification.Name {
    static let playoffsUpdated = Notification.Name("update_playoffs_notification")
}
