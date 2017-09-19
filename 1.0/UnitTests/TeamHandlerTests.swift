import XCTest

class TeamHandlerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // test for
    // +(NSString *)getTeamCity:(NSString *)teamABR
    func testGetTeamCityForNilAbbreviation() {
        
        let actualResult = TeamHandler.getTeamCity(nil)
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamCityForEmptyAbbreviation() {
        
        let actualResult = TeamHandler.getTeamCity("")
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamCityForNonDefinedAbbreviation() {
        
        let actualResult = TeamHandler.getTeamCity("ttyl")
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamCityForNonDefinedUppercaseAbbreviation() {
        
        let actualResult = TeamHandler.getTeamCity("TTYL")
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamCityForCorrectAbbreviation() {
        
        let actualResult = TeamHandler.getTeamCity("ana")
        let expectedResult = "Anaheim"
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamCityForCorrectUppercaseAbbreviation() {
        
        let actualResult = TeamHandler.getTeamCity("ANA")
        let expectedResult = "Anaheim"
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    // test for
    // +(NSString *)getTeamName:(NSString *)teamABR
    func testGetTeamNameForNilAbbreviation() {
        
        let actualResult = TeamHandler.getTeamName(nil)
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamNameForEmptyAbbreviation() {
        
        let actualResult = TeamHandler.getTeamName("")
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamNameForNonDefinedAbbreviation() {
        
        let actualResult = TeamHandler.getTeamName("ttyl")
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamNameForNonDefinedUppercaseAbbreviation() {
        
        let actualResult = TeamHandler.getTeamName("TTYL")
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamNameForCorrectAbbreviation() {
        
        let actualResult = TeamHandler.getTeamName("ana")
        let expectedResult = "Ducks"
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamNameForCorrectUppercaseAbbreviation() {
        
        let actualResult = TeamHandler.getTeamName("ANA")
        let expectedResult = "Ducks"
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    // test for
    // +(NSString *)getTeamABR:(NSString *)teamName
    func testGetTeamAbbreviationForNilName() {
        
        let actualResult = TeamHandler.getTeamABR(nil)
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamAbbreviationForEmptyName() {
        
        let actualResult = TeamHandler.getTeamABR("")
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamAbbreviationForNonDefinedName() {
        
        let actualResult = TeamHandler.getTeamABR("dinosaurs")
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamAbbreviationForNonDefinedUppercaseName() {
        
        let actualResult = TeamHandler.getTeamABR("DINOSAURS")
        let expectedResult = ""
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamAbbreviationForCorrectName() {
        
        let actualResult = TeamHandler.getTeamABR("ducks")
        let expectedResult = "ana"
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamAbbreviationForCorrectUppercaseName() {
        
        let actualResult = TeamHandler.getTeamABR("DUCKS")
        let expectedResult = "ana"
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    // tests for
    // +(UIColor *)getTeamColor:(NSString *)teamABR
    func testGetTeamColorForNilName() {
        
        let actualResult = TeamHandler.getTeamColor(nil)
        let expectedResult = Colors.lightGrayColor()
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamColorForEmptyName() {
        
        let actualResult = TeamHandler.getTeamColor("")
        let expectedResult = Colors.lightGrayColor()
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamColorForNonDefinedName() {
        
        let actualResult = TeamHandler.getTeamColor("ttyl")
        let expectedResult = Colors.lightGrayColor()
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamColorForNonDefinedUppercaseName() {
        
        let actualResult = TeamHandler.getTeamColor("TTYL")
        let expectedResult = Colors.lightGrayColor()
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamColorForCorrectName() {
        
        let actualResult = TeamHandler.getTeamColor("ana")
        let expectedResult = UIColor(red: 201.0/255.0, green: 63.0/255.0, blue: 16.0/255.0, alpha: 1.0)
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testGetTeamColorForCorrectUppercaseName() {
        
        let actualResult = TeamHandler.getTeamColor("ana")
        let expectedResult = UIColor(red: 201.0/255.0, green: 63.0/255.0, blue: 16.0/255.0, alpha: 1.0)
        
        XCTAssertEqual(actualResult, expectedResult)
    }
}
