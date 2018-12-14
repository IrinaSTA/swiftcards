//
//  CardTest.swift
//  SwiftCardsTests
//
//  Created by Chris Cooksley on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import XCTest
@testable import SwiftCards

class CardTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAttributes() {
        let card = Card(value: "1", suit: "hearts", location: "playarea", imageURL: "image")
        XCTAssertEqual(card.value, "1")
        XCTAssertEqual(card.suit, "hearts")
        XCTAssertEqual(card.location, "playarea")
        XCTAssertEqual(card.imageURL, "image")
        XCTAssertEqual(card.xPosition, nil)
        XCTAssertEqual(card.yPosition, nil)
    }
    func testSetCoords() {
        let card = Card(value: "1", suit: "hearts", location: "playarea", imageURL: "image")
        card.setCoords(x: 20, y: 50)
        XCTAssertEqual(card.xPosition, 20)
        XCTAssertEqual(card.yPosition, 50)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
