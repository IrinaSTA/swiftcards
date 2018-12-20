//
//  SwiftCardsUITests.swift
//  SwiftCardsUITests
//
//  Created by Chris Cooksley on 10/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import XCTest

class SwiftCardsUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }
    func testHomePage() {
        app.launch()
        let singlePlayerButton = app.buttons["Single Player"]
        let multiplayerButton = app.buttons["Multiplayer"]
        XCTAssert(singlePlayerButton.exists)
        XCTAssert(multiplayerButton.exists)
    }
    func testSetUpPage() {
        app.launch()
        app.buttons["Single Player"].tap()
        let enterHandSizeText = app.staticTexts["Please enter the number of cards per hand:"]
        XCTAssert(enterHandSizeText.exists)

        let handSizeField = app.textFields["handSizeText"]
        handSizeField.tap()
        handSizeField.typeText("6")
        app.buttons["Play"].tap()
        XCTAssertEqual(app.images.count, 7)
    }
    func testDeckDraw() {
        app.launch()
        app.buttons["Single Player"].tap()
        let handSizeField = app.textFields["handSizeText"]
        handSizeField.tap()
        handSizeField.typeText("6")
        app.buttons["Play"].tap()
        app.images["Deck"].tap()
        XCTAssertEqual(app.images.count, 8)
    }

}
