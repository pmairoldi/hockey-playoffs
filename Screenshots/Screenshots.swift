import XCTest

@MainActor
class Screenshots: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        app.launchArguments += ["-date", "\"2025-05-01 00:00:00\""]
        
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testScreenshots() {
        let round = 1
        let series = 3;
        let game = 3;
            
        let app = XCUIApplication()

        app.tabBars.buttons["Recent"].tap()
        screenshot("5-Recent")
        
        app.tabBars.buttons["Bracket"].tap()
        screenshot("1-Bracket")
                
        app.collectionViews.children(matching: .cell)["Series-\(round)\(series)"].tap()
        screenshot("2-Series")
        
        app.tables.element.cells["Game-\(round)\(series)\(game)"].tap()
        screenshot("3-Game")

        app.buttons.matching(identifier: "Play Highlights").allElementsBoundByIndex.first(where: { $0.isHittable })!.tap()
        XCUIDevice.shared.orientation = .landscapeRight
        sleep(4)
        app.otherElements["Video"].tap();
        snapshot("4-Video")
    }
    
    func screenshot(_ name: String) {
        XCUIDevice.shared.appearance = .light
        snapshot("\(name)-\(XCUIDevice.shared.appearance.toString())")
        XCUIDevice.shared.appearance = .dark
        snapshot("\(name)-\(XCUIDevice.shared.appearance.toString())")
    }
}

extension XCUIDevice.Appearance {
    func toString() -> String {
        self == .dark ? "dark" : "light"
    }
}
