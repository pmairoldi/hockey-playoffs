import XCTest

class Screenshots: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        app.launchArguments += ["-date", "\"2023-04-17 00:00:00\""]
        
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        let app = XCUIApplication()
        
        app.tabBars.buttons["Recent"].tap()
        snapshot("5-Recents")
        
        app.tabBars.buttons["Bracket"].tap()
        snapshot("1-Bracket")
        
        app.collectionViews.children(matching: .cell)["Series-11"].tap()
        snapshot("2-Series")
        
        app.tables.element.cells["Game-111"].tap()
        snapshot("3-Game")
        
//        app.tables.element.buttons["Play Highlights"].tap()
//        XCUIDevice.shared.orientation = .landscapeRight
//        sleep(4)
//        app.otherElements["Video"].tap();
//        snapshot("4-Video", timeWaitingForIdle: 0)
    }
}
