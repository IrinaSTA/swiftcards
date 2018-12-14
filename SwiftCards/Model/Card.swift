//
//  Card.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import Foundation

class Card: Equatable {
    var value: String
    var suit: String
    var location: String
    var imageURL: String
    var name: String
    var xPosition: Int?
    var yPosition: Int?
    init(value: String, suit: String, location: String, imageURL: String) {
        self.value = value
        self.suit = suit
        self.location = location
        self.imageURL = imageURL
        self.name = self.value + self.suit.prefix(1).uppercased()
    }
    func setCoords(x: Int, y: Int) {
        self.xPosition = x
        self.yPosition = y
    }

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.name == rhs.name
    }
}
