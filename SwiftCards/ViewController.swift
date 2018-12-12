//
//  ViewController.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 10/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import UIKit

let player = Player()
var game = Game(handSize: 5, players: [player])

class ViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var handSizeText: UITextField!
    @IBOutlet weak var deckImage: UIImageView!
    @IBOutlet weak var handView: UIView!
    // MARK: Actions
    @IBAction func play(_ sender: UIButton) {
        game.handSize = enteredHandSize()
    }
    @IBAction func deckTapped(_ sender: Any) {
        if player.hand.cards.count < 10 {
            player.draw(deck: game.deck)
        }
        if let card = player.hand.cards.last {
            render(player: player, card: card, location: handView)
        }
    }
    @IBAction func load(_ sender: UIButton) {
        game.deck.shuffle()
        game.deal()
        for card in player.hand.cards {
            render(player: player, card: card, location: handView)
        }
    }
    // Methods or functions
    func enteredHandSize() -> Int {
        let total = Int(handSizeText.text!) ?? 7
        return total
    }
    func render(player: Player, card: Card, location: UIView) {
        if let index = player.hand.cards.index(of: card) {
            let leftPosition = index * 30
            let image = UIImage(named: card.name + ".png")
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: leftPosition, y: 0, width: 90, height: 130)
            location.addSubview(imageView)
        }
    }
}
