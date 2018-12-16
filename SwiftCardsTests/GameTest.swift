//
//  GameTest.swift
//  SwiftCardsTests
//
//  Created by Chris Cooksley on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import XCTest
import MultipeerConnectivity
@testable import SwiftCards

class GameTest: XCTestCase {
    var peerID1: MCPeerID!
    var peerID2: MCPeerID!
    var player1: Player!
    var player2: Player!
    var game: Game!
    override func setUp() {
        peerID1 = MCPeerID(displayName: "player1")
        peerID2 = MCPeerID(displayName: "player2")
        player1 = Player(peerID: peerID1)
        player2 = Player(peerID: peerID2)
        game = Game(handSize: 5, players: [player1, player2])
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGameProperties() {
        XCTAssert(game.players.contains(player1))
        XCTAssert(game.players.contains(player2))
        XCTAssertEqual(game.handSize, 5)
        XCTAssert(game.deck is Deck)
        XCTAssert(game.playarea is Playarea)
    }
    func testGameCanDeal() {
        game.deal()
        XCTAssertEqual(player1.hand.cards.count, 5)
        XCTAssertEqual(player2.hand.cards.count, 5)
        XCTAssertEqual(game.deck.cards.count, 42)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
