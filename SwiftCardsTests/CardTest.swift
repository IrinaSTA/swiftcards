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
    var card: Card!
    var card2: Card!
    override func setUp() {
        card = Card(value: "1", suit: "hearts")
        card2 = Card(value: "3", suit: "spades")
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    func testAttributes() {
        XCTAssertEqual(card.value, "1")
        XCTAssertEqual(card.suit, "hearts")
        XCTAssertEqual(card.xPosition, 0.0)
        XCTAssertEqual(card.yPosition, 0.0)
    }
    func testSetCoords() {
        card.setCoords(x: 20, y: 50)
        XCTAssertEqual(card.xPosition, 20)
        XCTAssertEqual(card.yPosition, 50)
    }
    func testCodable() {
        var data: Data!
        var decodedCard: Card!
        do {
            data = try JSONEncoder().encode(card)
        } catch {
            print("Oops!")
        }
        do {
            decodedCard = try JSONDecoder().decode(Card.self, from: data)
        } catch {
            print("Oops!")
        }
        XCTAssertEqual(card, decodedCard)
    }
    func testFaceDown() {
        XCTAssertEqual(card.display, "front")
        card.faceDown()
        XCTAssertEqual(card.display, "back")
    }
    func testFaceUp() {
        card.faceDown()
        card.faceUp()
        XCTAssertEqual(card.display, "front")
    }
    func testFlip() {
        card.faceUp()
        card.flip()
        XCTAssertEqual(card.display, "back")
        card.flip()
        XCTAssertEqual(card.display, "front")
    }
}
