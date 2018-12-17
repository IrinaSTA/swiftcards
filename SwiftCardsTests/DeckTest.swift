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

    var deck: Deck!
    var suits: [String]!
    var values: [String]!
    
    override func setUp() {
        deck = Deck()
        suits = ["hearts", "spades", "clubs", "diamonds"]
        values = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    }
    func testAttributes() {
        XCTAssertEqual(deck.cards.count, 52)
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
        let oldCards = deck.cards
        deck.shuffle()
        let newCards = deck.cards
        XCTAssert(oldCards != newCards)
    }
    func testRemoveTopCard() {
        let card1 = deck.cards[0]
        let removedCard = deck.removeTopCard()
        XCTAssertEqual(removedCard, card1)
        XCTAssertFalse(deck.cards.contains(card1))
    }
    func testCodable() {
        var data: Data!
        var decodedDeck: Deck!
        do {
            data = try JSONEncoder().encode(deck)
        } catch {
            print("Oops!")
        }
        do {
            decodedDeck = try JSONDecoder().decode(Deck.self, from: data)
        } catch {
            print("Oops!")
        }
        XCTAssertEqual(deck, decodedDeck)
    }

}
