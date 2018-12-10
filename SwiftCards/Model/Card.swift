//
//  Card.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 11/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import Foundation

class Card {
    var value: String?
    var suit: String?
    var location: String?
    var imageURL: String?
    var name: String
    init(attributes: [String: Any]) {
        self.value = attributes["value"] as? String
        self.suit = attributes["suit"] as? String
        self.location = attributes["location"] as? String
        self.imageURL = attributes["imageURL"] as? String
        self.name = self.value! + self.suit!.prefix(1).uppercased() as? String
    }
}
