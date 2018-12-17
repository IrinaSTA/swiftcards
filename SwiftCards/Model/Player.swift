//
//  Player.swift
//  SwiftCards
//
//  Created by Irina Baldwin on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class Player: Equatable, Codable {
    var hand = Hand()
    var displayName: String
    
    init(peerID: MCPeerID) {
        self.displayName = peerID.displayName
    }

    func draw(deck: Deck) {
        if deck.cards.count > 0 {
            let card = deck.removeTopCard()
            self.hand.add(card: card)
        }
    }
    func play(card: Card, location: Playarea) {
        let card = self.hand.remove(card: card)
        location.add(card: card)
    }
    func reclaim(card: Card, from playarea: Playarea) {
        let card = playarea.remove(card: card)
        self.hand.add(card: card)
    }
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.displayName == rhs.displayName
    }
}
