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
    func testGameReset() {
        game.deal()
        game.reset()
        XCTAssertEqual(player1.hand.cards.count, 0)
        XCTAssertEqual(game.deck.cards.count, 52)
    }
    func testAllCards() {
        game.deal()
        XCTAssertEqual(game.allCards().count, 52)
    }
    func testFind() {
        let card = game.deck.cards[10]
        XCTAssertEqual(game.find(name: card.name), card)
    }

    func testCodable() {
        var data: Data!
        var decodedGame: Game!
        do {
            data = try JSONEncoder().encode(game)
        } catch {
            print("Oops!")
        }
        do {
            decodedGame = try JSONDecoder().decode(Game.self, from: data)
        } catch {
            print("Oops!")
        }
        XCTAssertEqual(game, decodedGame)
    }
}
