import XCTest
@testable import HockeyPlayoffs

class StringHandlerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testNilStringAndNilRegex() {
//
//        let actualResult = StringHandler.compare(nil, withRegex: nil)
//        let expectedResult = false
//
//        XCTAssertEqual(actualResult, expectedResult)
//    }
    
    func testEmptyStringAndEmptyRegex() {
        
        let actualResult = StringHandler.compare("", withRegex: "")
        let expectedResult = false
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
//    func testEmptyStringAndNilRegex() {
//
//        let actualResult = StringHandler.compare("", withRegex: nil)
//        let expectedResult = false
//
//        XCTAssertEqual(actualResult, expectedResult)
//    }
    
//    func testNilStringAndEmptyRegex() {
//
//        let actualResult = StringHandler.compare(nil, withRegex: "")
//        let expectedResult = false
//
//        XCTAssertEqual(actualResult, expectedResult)
//    }
    
    func testCorrectStringAndWrongRegex() {
        
        let actualResult = StringHandler.compare("12", withRegex: "\\d{4}");
        let expectedResult = false;
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testCorrectStringAndCorrectRegex() {
        
        let actualResult = StringHandler.compare("1234", withRegex: "\\d{4}");
        let expectedResult = true;
        
        XCTAssertEqual(actualResult, expectedResult)
    }
}
