//
//  GaveViewControllerTest.swift
//  SwiftCardsTests
//
//  Created by Irina Baldwin on 20/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import XCTest
import MultipeerConnectivity
@testable import SwiftCards

class GameViewControllerTest: XCTestCase {

    var gameViewController: GameViewController!
    var player1: Player!
    var player2: Player!
    var players: [Player] = []
    var game: Game!

    override func setUp() {
        super.setUp()
        createGameViewController()
        createPlayers()
        createGame()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSetUpVariables() {
        gameViewController.setupVariables(game: self.game)
        XCTAssertEqual(gameViewController.game, game)
        XCTAssertEqual(gameViewController.playarea, game.playarea)
        XCTAssertEqual(gameViewController.deck, game.deck)
        XCTAssertEqual(gameViewController.players.count, 2)
        XCTAssertEqual(gameViewController.localPlayer, player1)
        XCTAssertEqual(gameViewController.otherPlayer, player2)
    }

    func createGameViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        gameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
//        _ = gameViewController.view
    }
    func createPlayers() {
        let peerID1 = MCPeerID(displayName: UIDevice.current.name)
        let peerID2 = MCPeerID(displayName: "Amy")
        let player1 = Player(peerID: peerID1)
        let player2 = Player(peerID: peerID2)
        let players = [player1, player2]
        self.player1 = player1
        self.player2 = player2
        self.players = players
    }
    func createGame() {
        let game = Game(handSize: 5, players: self.players)
        self.game = game
    }
}
