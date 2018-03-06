//
//  bioUITests.swift
//  bioUITests
//
//  Created by Bjorn Orri Saemundsson on 06/03/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import XCTest

class bioUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    func testSnapshot() {
        let app = XCUIApplication()
        snapshot("0_showtimes", waitForLoadingIndicator: true)
        let tables = app.tables
        tables.cells.firstMatch.tap()
        snapshot("1_detail")
        swipeBack(app)
        openTabBar(app)
        app.tabBars.buttons.element(boundBy: 1).tap()
        snapshot("2_upcoming")
    }

    private func swipeBack(_ app: XCUIApplication) {
        let p1 = app.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.5))
        let p2 = app.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.5))
        p1.press(forDuration: 0.5, thenDragTo: p2)
    }

    private func openTabBar(_ app: XCUIApplication) {
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 0).tap()
    }
}
