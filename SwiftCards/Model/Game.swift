//
//  Game.swift
//  
//
//  Created by Chris Cooksley on 11/12/2018.
//

import Foundation

class Game {
    var players: [Player]
    var handSize: Int
    var deck: Deck = Deck()
    init(handSize: Int, players: [Player]) {
        self.players = players
        self.handSize = handSize
    }
    
    func deal() {
        for player in self.players {
            for _ in 0..<self.handSize {
                player.draw(deck: self.deck)
            }
        }
    }
}
