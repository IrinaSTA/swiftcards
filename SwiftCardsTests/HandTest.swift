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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAttributes() {
        let hand = Hand()
        XCTAssertEqual(hand.cards.count, 0)
    }

    func testAdd() {
        let hand = Hand()
        let card = Card(value: "1", suit: "hearts", location: "playarea", imageURL: "image")
        hand.add(card: card)
        XCTAssert(hand.cards[0] === card)
    }
    func testRemove() {
        let hand = Hand()
        let card1 = Card(value: "1", suit: "hearts", location: "playarea", imageURL: "image")
        let card2 = Card(value: "2", suit: "hearts", location: "playarea", imageURL: "image2")
        hand.add(card: card1)
        hand.add(card: card2)
        let returnedCard = hand.remove(card: card2)
        XCTAssert(returnedCard === card2)
        XCTAssertEqual(hand.cards.count, 1)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
