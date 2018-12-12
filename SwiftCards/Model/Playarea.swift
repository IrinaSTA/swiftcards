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
    func showLastCard() -> Card {
        if let card = self.cards.last {
            print(card)
        }
    }
}
