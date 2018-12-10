//
//  Deck.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import Foundation

class Deck {
    let suits = ["hearts", "spades", "clubs", "diamonds"]
    let values = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    var cards: [Card] = []
    init() {
        for suit in suits {
            for value in values {
                let card = Card(value: value, suit: suit, location: "location", imageURL: "imageURL")
                self.cards.append(card)
            }
        }
    }
    
    func shuffle() {
        self.cards.shuffle()
    }
}
