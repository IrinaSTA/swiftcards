//
//  GameTest.swift
//  SwiftCardsTests
//
//  Created by Chris Cooksley on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import XCTest
@testable import SwiftCards

class GameTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGameHasPlayers() {
        let player1 = Player()
        let player2 = Player()
        let playerArray = [player1, player2]
        let game = Game(handSize: 5, players: playerArray)
        XCTAssert(game.players.contains(player1))
        XCTAssert(game.players.contains(player2))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
