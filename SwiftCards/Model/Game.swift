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
    init(handSize: Int, players: [Player]) {
        self.players = players
        self.handSize = handSize
    }
}
