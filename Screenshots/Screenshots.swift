import XCTest

@MainActor
class Screenshots: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        app.launchArguments += ["-date", "\"2026-04-21 12:00:00\""]
        
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testScreenshots() throws {
        let app = XCUIApplication()
        app.launchArguments += ["-date", "\"2026-04-21 12:00:00\""]
        setupSnapshot(app)
        let device = XCUIDevice.shared
        defer {
            device.orientation = .portrait
            device.appearance = .light
        }

        // Launch in each appearance rather than capturing mid-transition.
        for appearance in [XCUIDevice.Appearance.light, .dark] {
            app.terminate()
            device.orientation = .portrait
            // Force a transition: interrupted simulator runs can leave XCTest's
            // cached appearance out of sync with the actual display.
            device.appearance = appearance == .light ? .dark : .light
            device.appearance = appearance
            app.launch()
            let suffix = appearance.toString()

            app.buttons.matching(identifier: "Recent").firstMatch.tap()
            let dateFilter = app.navigationBars.buttons["Date Picker"].firstMatch
            XCTAssertTrue(dateFilter.waitForExistence(timeout: 5))
            snapshot("5-Recent-\(suffix)")
            attachScreenshot(app, name: "Review-Recent-\(suffix)")
            dateFilter.tap()
            snapshot("6-DatePicker-\(suffix)")
            attachScreenshot(app, name: "Review-Date-Picker-\(suffix)")
            app.terminate()
            app.launch()

            app.buttons.matching(identifier: "Bracket").firstMatch.tap()
            let matchup = app.collectionViews.cells["Series-12"]
            XCTAssertTrue(matchup.waitForExistence(timeout: 5))
            snapshot("1-Bracket-\(suffix)")
            attachScreenshot(app, name: "Review-Bracket-\(suffix)")

            matchup.tap()
            let game = app.tables.cells["Game-121"]
            XCTAssertTrue(game.waitForExistence(timeout: 5))
            snapshot("2-Series-\(suffix)")
            attachScreenshot(app, name: "Review-Series-\(suffix)")

            // Show the list beneath both system bars, not just its resting position.
            let seriesTable = app.tables.firstMatch
            let seriesTitle = app.staticTexts["Round 1"].firstMatch
            XCTAssertTrue(seriesTitle.exists)
            let titleY = seriesTitle.frame.minY
            seriesTable.swipeUp()
            XCTAssertTrue(seriesTitle.isHittable, "The navigation title must stay visible while scrolling")
            XCTAssertEqual(seriesTitle.frame.minY, titleY, accuracy: 1,
                                       "The navigation title must remain pinned while content scrolls")
            attachScreenshot(app, name: "Review-Series-Scrolled-\(suffix)")
            seriesTable.swipeDown()
            XCTAssertTrue(game.isHittable, "The first game must remain reachable after scrolling under the bars")
            game.tap()
            let sections = app.segmentedControls.firstMatch
            XCTAssertTrue(sections.waitForExistence(timeout: 5))
            reveal(sections, in: app.tables.firstMatch)
            XCTAssertTrue(sections.buttons["Goals"].isSelected)
            snapshot("3-Game-\(suffix)")
            attachScreenshot(app, name: "Review-Game-Goals-\(suffix)")

            sections.buttons["Penalties"].tap()
            XCTAssertTrue(sections.buttons["Penalties"].isSelected)
            snapshot("3-Game-Penalties-\(suffix)")
            attachScreenshot(app, name: "Review-Game-Penalties-\(suffix)")

            let highlights = try XCTUnwrap(app.buttons.matching(identifier: "Play Highlights")
                .allElementsBoundByIndex.first(where: { $0.isHittable }))
            XCTAssertTrue(highlights.isEnabled)
            highlights.tap()
            device.orientation = .landscapeRight
            sleep(4)
            let video = app.otherElements["Video"]
            XCTAssertTrue(video.waitForExistence(timeout: 5), "Highlights must open the native video player")
            if video.exists { video.tap() }
            snapshot("4-Video-\(suffix)")
            attachScreenshot(app, name: "Review-Video-\(suffix)")
        }
    }
    
    func testResizableNavigation() throws {
        let app = XCUIApplication()
        let device = XCUIDevice.shared
        defer { device.orientation = .portrait }

        for orientation in [UIDeviceOrientation.portrait, .landscapeRight, .landscapeLeft] {
            device.orientation = orientation
            app.buttons.matching(identifier: "Bracket").firstMatch.tap()
            let bracket = app.collectionViews.firstMatch
            XCTAssertTrue(bracket.waitForExistence(timeout: 5))

            // UIKit can expose collection/app frames in different coordinate
            // spaces during a rotation. Wait for an actually tappable matchup,
            // rather than intersecting those transient accessibility frames.
            let matchupReady = XCTNSPredicateExpectation(predicate: NSPredicate { _, _ in
                bracket.cells.allElementsBoundByIndex.contains { $0.isHittable }
            }, object: nil)
            XCTAssertEqual(XCTWaiter.wait(for: [matchupReady], timeout: 5), .completed)
            let visibleCells = bracket.cells.allElementsBoundByIndex.filter { $0.isHittable }
            let tabs = [app.buttons.matching(identifier: "Bracket").firstMatch,
                        app.buttons.matching(identifier: "Recent").firstMatch]
            for tab in tabs {
                XCTAssertTrue(tab.isHittable, "\(tab.label) must stay usable while content extends beneath it")
            }
            attachScreenshot(app, name: "Bracket-\(orientation.rawValue)")

            // Opening a matchup and returning must work after a resize.
            let matchup = try XCTUnwrap(visibleCells.first(where: { $0.isHittable }))
            matchup.tap()
            XCTAssertTrue(app.tables.firstMatch.waitForExistence(timeout: 5))
            let game = app.tables.cells.matching(NSPredicate(format: "identifier BEGINSWITH %@", "Game-")).firstMatch
            XCTAssertTrue(game.waitForExistence(timeout: 5))
            attachScreenshot(app, name: "Series-\(orientation.rawValue)")
            game.tap()
            XCTAssertTrue(app.segmentedControls.firstMatch.waitForExistence(timeout: 5))
            reveal(app.segmentedControls.firstMatch, in: app.tables.firstMatch)
            XCTAssertTrue(app.segmentedControls.firstMatch.isHittable)
            attachScreenshot(app, name: "Game-\(orientation.rawValue)")

            device.orientation = .portrait
            goBack(app)
            XCTAssertTrue(app.tables.firstMatch.waitForExistence(timeout: 5))
            goBack(app)
            XCTAssertTrue(bracket.waitForExistence(timeout: 5))

            app.buttons.matching(identifier: "Recent").firstMatch.tap()
            device.orientation = orientation
            let datePicker = app.navigationBars.buttons["Date Picker"].firstMatch
            XCTAssertTrue(datePicker.waitForExistence(timeout: 5),
                          "The date filter must stay in the navigation header")
            XCTAssertTrue(datePicker.isHittable, "Date selection must remain available after resizing")
            XCTAssertTrue(app.tables.firstMatch.exists)
            attachScreenshot(app, name: "Recent-\(orientation.rawValue)")

            // Preserve the original push/back behavior at every width.
            let recentGame = app.tables.cells.matching(NSPredicate(format: "identifier BEGINSWITH %@", "Game-")).firstMatch
            XCTAssertTrue(recentGame.waitForExistence(timeout: 5))
            recentGame.tap()
            let sections = app.segmentedControls.firstMatch
            XCTAssertTrue(sections.waitForExistence(timeout: 5))
            let detailTable = app.tables.firstMatch
            reveal(sections, in: detailTable)
            XCTAssertTrue(sections.isHittable)
            sections.buttons["Penalties"].tap()
            XCTAssertTrue(sections.buttons["Penalties"].isSelected)
            attachScreenshot(app, name: "Recent-Selected-\(orientation.rawValue)")
            if orientation == .portrait {
                device.appearance = .dark
                device.press(.home)
                app.activate()
                attachScreenshot(app, name: "Recent-Selected-Dark")
                device.appearance = .light
                device.press(.home)
                app.activate()
            }
            XCTAssertFalse(datePicker.exists, "Opening a game must replace the list, not add a detail pane")
            goBack(app)
            XCTAssertTrue(datePicker.waitForExistence(timeout: 5))
            XCTAssertTrue(datePicker.isHittable)
        }
    }

    private func reveal(_ element: XCUIElement, in table: XCUIElement) {
        for _ in 0..<5 where !element.isHittable {
            if element.frame.minY < table.frame.minY {
                table.swipeDown()
            } else {
                table.swipeUp()
            }
        }
    }

    private func goBack(_ app: XCUIApplication) {
        let verticalBack = app.buttons["BackButton"]
        if verticalBack.exists {
            verticalBack.tap()
        } else {
            app.navigationBars.buttons.firstMatch.tap()
        }
    }

    private func attachScreenshot(_ app: XCUIApplication, name: String) {
        // Duo's main-screen/app capture can be the inactive outer display.
        // Keep every screen so the active inner display is reviewable too.
        for (index, screen) in XCUIScreen.screens.enumerated() {
            let screenshot = screen.screenshot()
            // Keep review images even when Xcode fails to finalize its result bundle.
            if let directory = Snapshot.screenshotsDirectory {
                try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
                try? screenshot.pngRepresentation.write(to: directory.appendingPathComponent("\(name)-Screen\(index).png"))
            }
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.name = "\(name)-Screen\(index)"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }

}

extension XCUIDevice.Appearance {
    func toString() -> String {
        self == .dark ? "dark" : "light"
    }
}
