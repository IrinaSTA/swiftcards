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
        XCTAssertEqual(card.xPosition, 0.0)
        XCTAssertEqual(card.yPosition, 0.0)
    }
    func testSetCoords() {
        let card = Card(value: "1", suit: "hearts", location: "playarea", imageURL: "image")
        card.setCoords(x: 20, y: 50)
        XCTAssertEqual(card.xPosition, 20)
        XCTAssertEqual(card.yPosition, 50)
    }
    func testAll() {
        XCTAssertEqual(Card.all(), [])
        let card1 = Card(value: "1", suit: "hearts", location: "playarea", imageURL: "image")
        let card2 = Card(value: "3", suit: "spades", location: "playarea", imageURL: "image")
        XCTAssertEqual(Card.all(), [card1, card2])
    }
    func testFind() {
        let card = Card(value: "3", suit: "spades", location: "playarea", imageURL: "image")
        let foundCard = Card.find(name: "3S")
        XCTAssertEqual(foundCard, card)
    }
}
