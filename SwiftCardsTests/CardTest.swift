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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let attributes: [String: Any] = ["value": "1", "suit": "hearts", "location": "playarea", "imageURL": "image"]
        var card = Card(attributes: attributes)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAttributes() {
        XCTAssertEqual(card.value, "1")
        XCTAssertEqual(card.suit, "hearts")
        XCTAssertEqual(card.location, "playarea")
        XCTAssertEqual(card.imageURL, "image")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
