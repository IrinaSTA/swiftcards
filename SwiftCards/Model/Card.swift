//
//  Card.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import Foundation

class Card: Equatable {
    static var instances: [Card] = []
    var value: String
    var suit: String
    var location: String
    var imageURL: String
    var name: String
    var xPosition: Float?
    var yPosition: Float?
    init(value: String, suit: String, location: String, imageURL: String) {
        self.value = value
        self.suit = suit
        self.location = location
        self.imageURL = imageURL
        self.name = self.value + self.suit.prefix(1).uppercased()
        Card.instances.append(self)
    }
    func setCoords(x: Float, y: Float) {
        self.xPosition = x
        self.yPosition = y
    }

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.name == rhs.name
    }
    static func all() -> [Card] {
        return instances
    }
    static func find(name: String) -> Card {
        // TODO: prevent fatal error
        return Card.all().first(where: {$0.name == name})!
    }
}
