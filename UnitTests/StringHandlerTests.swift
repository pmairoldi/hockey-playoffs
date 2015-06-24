import XCTest

class StringHandlerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // tests for
    // +(BOOL)compareString:(NSString *)string withRegex:(NSString *)regex
    func testNilStringAndNilRegex() {
    
        let actualResult = StringHandler.compareString(nil, withRegex: nil)
        let expectedResult = false
    
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testEmptyStringAndEmptyRegex() {
    
        let actualResult = StringHandler.compareString("", withRegex: "")
        let expectedResult = false
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testEmptyStringAndNilRegex() {
    
        let actualResult = StringHandler.compareString("", withRegex: nil)
        let expectedResult = false
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testNilStringAndEmptyRegex() {
    
        let actualResult = StringHandler.compareString(nil, withRegex: "")
        let expectedResult = false
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testCorrectStringAndWrongRegex() {
    
        let actualResult = StringHandler.compareString("12", withRegex: "\\d{4}");
        let expectedResult = false;
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
    
    func testCorrectStringAndCorrectRegex() {
    
        let actualResult = StringHandler.compareString("1234", withRegex: "\\d{4}");
        let expectedResult = true;
        
        XCTAssertEqual(actualResult, expectedResult, "actual result: \(actualResult), expected results: \(expectedResult)")
    }
}
