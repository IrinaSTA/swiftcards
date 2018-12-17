//
//  Player.swift
//  SwiftCards
//
//  Created by Irina Baldwin on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import Foundation

class Player: Equatable {
    var hand = Hand()

    func draw(deck: Deck) {
        if deck.cards.count > 0 {
            let card = deck.removeTopCard()
            self.hand.add(card: card)
        }
    }
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs === rhs
    }
}
