//
//  Playarea.swift
//  SwiftCards
//
//  Created by Caitlin Cooling on 12/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import Foundation

class Playarea {
    var cards: [Card] = []
    func add(card: Card) {
        self.cards.append(card)
    }
    func remove(card: Card) -> Card {
        if let index = self.cards.index(of: card) {
            self.cards.remove(at: index)
        }
        return card
    }
}
