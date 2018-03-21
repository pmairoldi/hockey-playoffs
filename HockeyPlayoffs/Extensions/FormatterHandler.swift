import Foundation

class FormatterHandler {
    static let sharedHandler = FormatterHandler()

    private let _fullDateFormatter: DateFormatter
    private let _fullDateTimeFormatter: DateFormatter
    private let _longDateFormatter: DateFormatter
    private let _timeFormatter: DateFormatter

    private init() {
        let en_US = Locale(identifier: "en_US")

        _fullDateFormatter = DateFormatter()
        _fullDateFormatter.locale = en_US
        _fullDateFormatter.dateFormat = "yyyy-MM-dd"

        _fullDateTimeFormatter = DateFormatter()
        _fullDateTimeFormatter.locale = en_US
        _fullDateTimeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        _longDateFormatter =  DateFormatter()
        _longDateFormatter.dateFormat = "MMM d, yyyy"

        _timeFormatter =  DateFormatter()
        _longDateFormatter.dateFormat = "h:mm a"
    }

    static func fullDateFormatter() -> DateFormatter {
        return sharedHandler._fullDateFormatter
    }

    static func fullDateTimeFormatter() -> DateFormatter {
        return sharedHandler._fullDateTimeFormatter
    }

    static func longDateFormatter() -> DateFormatter {
        return sharedHandler._longDateFormatter
    }

    static func timeFormatter() -> DateFormatter {
        return sharedHandler._timeFormatter
    }
}
