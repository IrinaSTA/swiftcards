//
//  PlayerTest.swift
//  SwiftCardsTests
//
//  Created by Irina Baldwin on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import XCTest
@testable import SwiftCards

class PlayerTest: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testPlayerHasHandOfCertainSize() {
        let player = Player()
        XCTAssertEqual(player.hand.cards.count, 0)
    }
    func testPlayerCanDraw() {
        let player = Player()
        let deck = Deck()
        player.draw(deck: deck)
        XCTAssertEqual(player.hand.cards.count, 1)
    }
    func testPlayerCanPlay() {
        let player = Player()
        let deck = Deck()
        player.draw(deck: deck)
        let card = player.hand.cards[0]
        let playarea = Playarea()
        player.play(card: card, location: playarea)
        XCTAssertEqual(playarea.cards[0], card)
        XCTAssertEqual(player.hand.cards.count, 0)
    }
    func testPlayerCanReclaim() {
        let player = Player()
        let deck = Deck()
        player.draw(deck: deck)
        let card = player.hand.cards[0]
        let playarea = Playarea()
        player.play(card: card, location: playarea)
        player.reclaim(card: card, from: playarea)
        XCTAssertEqual(player.hand.cards[0], card)
        XCTAssertEqual(playarea.cards.count, 0)
    }
}
