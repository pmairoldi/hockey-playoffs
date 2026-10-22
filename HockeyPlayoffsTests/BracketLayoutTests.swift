import UIKit
import XCTest

@testable import HockeyPlayoffs

@MainActor
final class BracketLayoutTests: XCTestCase {
    func testReusedConnectorRedrawsWithoutResizing() {
        let bracket = BracketView()
        bracket.bounds = CGRect(x: 0, y: 0, width: 402, height: 700)
        let connector = BracketSection(frame: CGRect(x: 0, y: 0, width: 402, height: 40))
        let renderer = UIGraphicsImageRenderer(size: connector.bounds.size)
        func image() -> Data? {
            connector.layoutIfNeeded()
            connector.layer.displayIfNeeded()
            return renderer.image { connector.layer.render(in: $0.cgContext) }.pngData()
        }
        connector.configure(bracket: bracket, section: 1)
        let quarterfinal = image()
        connector.prepareForReuse()
        connector.configure(bracket: bracket, section: 2)
        let semifinal = image()
        XCTAssertNotNil(quarterfinal)
        XCTAssertNotNil(semifinal)
        XCTAssertNotEqual(quarterfinal, semifinal, "Reusing an equal-sized header must redraw its new connections")
    }

    func testConnectorsTrackMatchupsAfterResizing() throws {
        let controller = BracketViewController()
        controller.loadViewIfNeeded()
        let bracket = try XCTUnwrap(controller.view.subviews.compactMap { $0 as? BracketView }.first)
        for size in [
            CGSize(width: 382, height: 644), CGSize(width: 867, height: 635), CGSize(width: 585, height: 917),
            CGSize(width: 750, height: 338), CGSize(width: 382, height: 644),
        ] {
            controller.view.bounds = CGRect(origin: .zero, size: size)
            controller.view.layoutIfNeeded()
            bracket.reloadData()
            bracket.layoutIfNeeded()
            for section in BracketModel.counts.indices {
                let endpoints = bracket.endpoints(section)
                XCTAssertEqual(endpoints.count, BracketModel.counts[section])
                for item in endpoints.indices {
                    let attributes = try XCTUnwrap(
                        bracket.layoutAttributesForItem(at: IndexPath(item: item, section: section)))
                    XCTAssertEqual(
                        attributes.frame.midX, endpoints[item].midX, accuracy: 1,
                        "Connector must meet its matchup after resizing to \(size)")
                    if (2...4).contains(section) {
                        XCTAssertEqual(endpoints[item].midX, bracket.bounds.midX, accuracy: 0.01)
                        // Flow layout aligns item origins to physical pixels. An
                        // odd-pixel container may put its center on a half pixel.
                        let halfPixel = 0.5 / max(bracket.traitCollection.displayScale, 1)
                        XCTAssertEqual(attributes.frame.midX, bracket.bounds.midX, accuracy: halfPixel + 0.001)
                    }
                }
            }
        }
    }
}
