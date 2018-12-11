//
//  DeckTest.swift
//  SwiftCardsTests
//
//  Created by Chris Cooksley on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import XCTest
@testable import SwiftCards

class DeckTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAttributes() {
        let deck = Deck()
        XCTAssertEqual(deck.cards.count, 52)
        let suits = ["hearts", "spades", "clubs", "diamonds"]
        let values = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
        var containsAllCards = true
        for suit in suits {
            for value in values {
                let name = value + suit.prefix(1).uppercased()
                if !(deck.cards.contains {$0.name == name}) {
                    containsAllCards = false
                }
            }
        }
        XCTAssert(containsAllCards)
    }
    func testShuffleDeck() {
        // We would like to come back to this and stub the randomness, but we need to push on!
        let deck = Deck()
        let oldCards = deck.cards
        deck.shuffle()
        let newCards = deck.cards
        XCTAssert(oldCards != newCards)
    }
    func testRemoveTopCard() {
        let deck = Deck()
        let card1 = deck.cards[0]
        let removedCard = deck.removeTopCard()
        XCTAssertEqual(removedCard, card1)
        XCTAssertFalse(deck.cards.contains(card1))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
