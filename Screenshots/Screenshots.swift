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
    
    func testLight() {
        XCUIDevice.shared.appearance = .light
        takeScreenshots()
    }
    
    func testDark() {
        XCUIDevice.shared.appearance = .dark
        takeScreenshots()
    }
    
    func takeScreenshots() {
        let round = 1
        let series = 3;
        let game = 3;
        let appearance = XCUIDevice.shared.appearance.toString();
        
        let app = XCUIApplication()

        app.tabBars.buttons["Recent"].tap()
        snapshot("5-Recent-\(appearance)")
        
        app.tabBars.buttons["Bracket"].tap()
        snapshot("1-Bracket-\(appearance)")
                
        app.collectionViews.children(matching: .cell)["Series-\(round)\(series)"].tap()
        snapshot("2-Series-\(appearance)")
        
        app.tables.element.cells["Game-\(round)\(series)\(game)"].tap()
        snapshot("3-Game-\(appearance)")

        app.buttons.matching(identifier: "Play Highlights").allElementsBoundByIndex.first(where: { $0.isHittable })!.tap()
        XCUIDevice.shared.orientation = .landscapeRight
        sleep(4)
        app.otherElements["Video"].tap();
        snapshot("4-Video-\(appearance)")
    }
}

extension XCUIDevice.Appearance {
    func toString() -> String {
        self == .dark ? "dark" : "light"
    }
}
