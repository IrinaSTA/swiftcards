//
//  Game.swift
//
//
//  Created by Chris Cooksley on 11/12/2018.
//

import Foundation

class Game: Equatable, Codable {
    var players: [Player]
    var deck: Deck = Deck()
    var playarea: Playarea = Playarea()
    var handSize: Int
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
    func reset() {
        deck = Deck()
        for player in self.players {
          player.hand = Hand()
        }
    }
    static func == (lhs: Game, rhs: Game) -> Bool {
        return (lhs.deck == rhs.deck) && (lhs.playarea == rhs.playarea) && (lhs.players == rhs.players)
    }
}
