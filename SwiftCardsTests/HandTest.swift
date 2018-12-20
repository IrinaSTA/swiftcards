//
//  HandTest.swift
//  SwiftCardsTests
//
//  Created by Chris Cooksley on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import XCTest
@testable import SwiftCards

class HandTest: XCTestCase {
    var card1: Card!
    var card2: Card!
    var hand: Hand!
    override func setUp() {
        card1 = Card(value: "1", suit: "hearts")
        card2 = Card(value: "2", suit: "hearts")
        hand = Hand()
    }
    func testAttributes() {
        XCTAssertEqual(hand.cards.count, 0)
    }
    func testAdd() {
        hand.add(card: card1)
        XCTAssert(hand.cards[0] === card1)
    }
    func testRemove() {
        hand.add(card: card1)
        hand.add(card: card2)
        let returnedCard = hand.remove(card: card2)
        XCTAssert(returnedCard === card2)
        XCTAssertEqual(hand.cards.count, 1)
    }
    func testCodable() {
        var data: Data!
        var decodedHand: Hand!
        hand.add(card: card1)
        hand.add(card: card2)
        do {
            data = try JSONEncoder().encode(hand)
        } catch {
            print("Oops!")
        }
        do {
            decodedHand = try JSONDecoder().decode(Hand.self, from: data)
        } catch {
            print("Oops!")
        }
        XCTAssertEqual(hand, decodedHand)
    }
}
