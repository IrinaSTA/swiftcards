//
//  PlayerTest.swift
//  SwiftCardsTests
//
//  Created by Irina Baldwin on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import XCTest
import MultipeerConnectivity
@testable import SwiftCards

class PlayerTest: XCTestCase {
    
    var peerID: MCPeerID!
    var player: Player!
    var deck: Deck!
    var playarea: Playarea!
    
    override func setUp() {
        super.setUp()
        deck = Deck()
        playarea = Playarea()
        peerID = MCPeerID(displayName: "player")
        player = Player(peerID: peerID)
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testPlayerHasHandOfCertainSize() {
        XCTAssertEqual(player.hand.cards.count, 0)
    }
    func testPlayerHasPeerID() {
        XCTAssertEqual(player.peerID, peerID)
    }
    func testPlayerCanDraw() {
        player.draw(deck: deck)
        XCTAssertEqual(player.hand.cards.count, 1)
    }
    func testPlayerCanPlay() {
        player.draw(deck: deck)
        let card = player.hand.cards[0]
        player.play(card: card, location: playarea)
        XCTAssertEqual(playarea.cards[0], card)
        XCTAssertEqual(player.hand.cards.count, 0)
    }
    func testPlayerCanReclaim() {
        player.draw(deck: deck)
        let card = player.hand.cards[0]
        player.play(card: card, location: playarea)
        player.reclaim(card: card, from: playarea)
        XCTAssertEqual(player.hand.cards[0], card)
        XCTAssertEqual(playarea.cards.count, 0)
    }
}
