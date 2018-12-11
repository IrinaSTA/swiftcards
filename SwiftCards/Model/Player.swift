//
//  Player.swift
//  SwiftCards
//
//  Created by Irina Baldwin on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import Foundation

class Player {
    var hand = Hand()

    func draw(deck: Deck) {
        let card = deck.removeTopCard()
        self.hand.add(card: card)
    }
}
