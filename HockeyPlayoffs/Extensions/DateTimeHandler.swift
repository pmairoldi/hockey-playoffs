import Foundation

class DateTimeHandler {

    static func getDate(forDate date: String, andTime time: String) -> String {

        if !StringHandler.compare(date, withRegex: "\\d{4}-\\d{2}-\\d{2}") {
            return ""
        }

        let formattedDate = self.convertToTimeZone(forDate: date, andTime: time)
        let formatter =  FormatterHandler.longDateFormatter()

        return formatter.string(from: formattedDate)
    }

    static func getTime(forDate date: String, andTime time: String) -> String {

        if !StringHandler.compare(time, withRegex: "\\d{2}:\\d{2}:\\d{2}") {
            return NSLocalizedString("time.tbd", comment: "Time to be determined")
        }

        let formattedDate = self.convertToTimeZone(forDate: date, andTime: time)
        let formatter = FormatterHandler.timeFormatter()

        return formatter.string(from: formattedDate)
    }

    static func getString(forDate date: Date) -> String {

        let convertedDate = self.convertFromTimeZone(forDate: date)
        let formatter = FormatterHandler.fullDateFormatter()

        return formatter.string(from: convertedDate)
    }

    private static func convertToTimeZone(forDate date: String, andTime time: String) -> Date {

        let formatter = FormatterHandler.fullDateTimeFormatter()
        let combinedDate = "\(date.count == 0 ? "1970-01-01" : date) \(time.count == 0 ? "00:00:00" : time)"

        guard let sourceDate = formatter.date(from: combinedDate), let sourceTimeZone = NSTimeZone(abbreviation: "EST") else {
            return Date(timeIntervalSince1970: 0)
        }

        let destinationTimeZone = NSTimeZone.default

        let sourceGMTOffset = sourceTimeZone.secondsFromGMT(for: sourceDate)
        let destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: sourceDate)
        let interval = TimeInterval(destinationGMTOffset - sourceGMTOffset)

        let destinationDate = Date(timeInterval: interval, since: sourceDate)

        return destinationDate
    }

    private static func convertFromTimeZone(forDate date: Date) -> Date {

        guard let destinationTimeZone = NSTimeZone(abbreviation: "EST") else {
            return Date(timeIntervalSince1970: 0)
        }

        let sourceTimeZone = NSTimeZone.default

        let sourceGMTOffset =  sourceTimeZone.secondsFromGMT(for: date)
        let destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: date)
        let interval = TimeInterval(destinationGMTOffset - sourceGMTOffset)

        let destinationDate = Date(timeInterval: interval, since: date)

        return destinationDate
    }
}
