//
//  PlayareaTest.swift
//  SwiftCardsTests
//
//  Created by Caitlin Cooling on 12/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import XCTest
@testable import SwiftCards

class PlayareaTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAttributes() {
       let playarea = Playarea()
        XCTAssertEqual(playarea.cards.count, 0)
    }
    func testAddCard() {
       let playarea = Playarea()
        let card = Card(value: "2", suit: "hearts", location: "hand", imageURL: "image")
        playarea.add(card: card)
        XCTAssertEqual(playarea.cards.count, 1)
    }
    func testRemoveCard() {
        let playarea = Playarea()
        let card = Card(value: "2", suit: "hearts", location: "hand", imageURL: "image")
        playarea.add(card: card)
        let removedCard = playarea.remove(card: card)
        XCTAssertEqual(playarea.cards.count, 0)
        XCTAssertEqual(removedCard, card)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
