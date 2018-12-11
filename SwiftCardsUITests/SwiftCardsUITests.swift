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
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
//        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHomePage() {
        app.launch()
        let enterHandSizeText = app.staticTexts["Please enter the number of cards per hand:"]
        XCTAssert(enterHandSizeText.exists)

        let handSizeField = app.textFields["handSizeText"]
        handSizeField.tap()
        handSizeField.typeText("5")
        app.buttons["Play"].tap()
    }

}
