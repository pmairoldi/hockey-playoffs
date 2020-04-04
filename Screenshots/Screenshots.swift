import XCTest

class Screenshots: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        app.launchArguments += ["-date", "\"2019-04-15 00:00:00\""]
        
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let app = XCUIApplication()
        
        app.tabBars.buttons["Recent"].tap()
        snapshot("5-Recents")
        
        app.tabBars.buttons["Bracket"].tap()
        snapshot("1-Bracket")
        
        app.collectionViews.children(matching: .cell)["Series-41"].tap()
        snapshot("2-Series")
        
        app.tables.element.cells["Game-411"].tap()
        snapshot("3-Game")
        
        app.tables.element.buttons["Play Highlights"].tap()
        XCUIDevice.shared.orientation = .landscapeRight
        sleep(4)
        app.otherElements["Video"].tap();
        snapshot("4-Video", timeWaitingForIdle: 0)
    }
}
