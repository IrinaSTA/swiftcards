//
//  Card.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import Foundation

class Card: Equatable, Codable {
    var value: String
    var suit: String
    var name: String
    var xPosition: Float = 0.0
    var yPosition: Float = 0.0
    init(value: String, suit: String) {
        self.value = value
        self.suit = suit
        self.name = self.value + self.suit.prefix(1).uppercased()
    }
    func setCoords(x: Float, y: Float) {
        self.xPosition = x
        self.yPosition = y
    }

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.name == rhs.name
    }
}
