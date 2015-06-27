import XCTest

class DateTimeHandlerTests: XCTestCase {
    
    let cachedTimeZone = NSTimeZone.defaultTimeZone()
    
    override func setUp() {
        super.setUp()
        
        NSTimeZone.setDefaultTimeZone(NSTimeZone(abbreviation: "EST")!)
    }
    
    override func tearDown() {

        NSTimeZone.setDefaultTimeZone(cachedTimeZone)
        
        super.tearDown()
    }
    
    // tests for
    // +(NSString *)getDateForDate:(NSString *)date andTime:(NSString *)time
    func testDateFromEmptyDateAndEmptyTime() {
        
        let actualResult = DateTimeHandler.getDateForDate("", andTime: "")
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testDateFromNilDateAndNilTime() {
        
        let actualResult = DateTimeHandler.getDateForDate(nil, andTime: nil)
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testDateFromEmptyDateAndNilTime() {
        
        let actualResult = DateTimeHandler.getDateForDate("", andTime: nil)
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testDateFromNilDateAndEmptyTime() {
        
        let actualResult = DateTimeHandler.getDateForDate(nil, andTime: "")
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testDateFromIncorectlyFormattedDateAndNilTime() {
        
        let actualResult = DateTimeHandler.getDateForDate("22/6/2015", andTime: nil)
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testDateFromIncorectlyFormattedDateAndEmptyTime() {
        
        let actualResult = DateTimeHandler.getDateForDate("22/6/2015", andTime: "")
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testDateFromWellFormattedDateAndNilTime() {
        
        let actualResult = DateTimeHandler.getDateForDate("2015-06-22", andTime: nil)
        let expectedResult = "Jun 22, 2015"
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testDateFromWellFormattedDateAndEmptyTime() {
        
        let actualResult = DateTimeHandler.getDateForDate("2015-06-22", andTime: "")
        let expectedResult = "Jun 22, 2015"
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testDateFromWellFormattedDateAndTime() {
        
        let actualResult = DateTimeHandler.getDateForDate("2015-06-22", andTime: "10:53:00")
        let expectedResult = "Jun 22, 2015"
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    // tests for
    // +(NSString *)getTimeForDate:(NSString *)date andTime:(NSString *)time
    func testTimeFromEmptyDateAndEmptyTime() {
        
        let actualResult = DateTimeHandler.getTimeForDate("", andTime: "")
        let expectedResult = NSLocalizedString("time.tbd", comment: "")
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testTimeFromNilDateAndNilTime() {
        
        let actualResult = DateTimeHandler.getTimeForDate(nil, andTime: nil)
        let expectedResult = NSLocalizedString("time.tbd", comment: "")
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testTimeFromEmptyDateAndNilTime() {
        
        let actualResult = DateTimeHandler.getTimeForDate("", andTime: nil)
        let expectedResult = NSLocalizedString("time.tbd", comment: "")
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testTimeFromNilDateAndEmptyTime() {
        
        let actualResult = DateTimeHandler.getTimeForDate(nil, andTime: "")
        let expectedResult = NSLocalizedString("time.tbd", comment: "")
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testTimeFromIncorectlyFormattedTimeAndNilDate() {
        
        let actualResult = DateTimeHandler.getTimeForDate(nil, andTime: "10:00 PM")
        let expectedResult = NSLocalizedString("time.tbd", comment: "")
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testTimeFromIncorectlyFormattedTimeAndEmptyDate() {
        
        let actualResult = DateTimeHandler.getTimeForDate("", andTime: "10:00 PM")
        let expectedResult = NSLocalizedString("time.tbd", comment: "")
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testTimeFromWellFormattedTimeAndNilDate() {
        
        let actualResult = DateTimeHandler.getTimeForDate(nil, andTime: "10:53:00")
        let expectedResult = "10:53 AM"
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testTimeFromWellFormattedTimeAndEmptyDate() {
        
        let actualResult = DateTimeHandler.getTimeForDate("", andTime: "10:53:00")
        let expectedResult = "10:53 AM"
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testTimeFromWellFormattedDateAndTime() {
        
        let actualResult = DateTimeHandler.getTimeForDate("2015-06-22", andTime: "10:53:00")
        let expectedResult = "10:53 AM"
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    // tests for
    // +(NSString *)getStringForDate:(NSDate *)date
    func testStringDateFromNilDate() {
        
        let actualResult = DateTimeHandler.getStringForDate(nil)
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testStringDateFromIncorrectlyFormattedDate() {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateFormatter.dateFromString("1970-01-01 00:00:00")
        
        let actualResult = DateTimeHandler.getStringForDate(date)
        let expectedResult = "1970-01-01"
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testStringDateFromWellFormattedDate() {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.dateFromString("1970-01-01")
        
        let actualResult = DateTimeHandler.getStringForDate(date)
        let expectedResult = "1970-01-01"
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
}
