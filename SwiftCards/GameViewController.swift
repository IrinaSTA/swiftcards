//
//  GameViewController.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 12/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import UIKit

let player = Player()
var game = Game(handSize: 5, players: [player])
let playarea = Playarea()

class GameViewController: UIViewController {
    @IBOutlet weak var deckImage: UIImageView!
    @IBOutlet weak var handView: UIView!
    @IBOutlet weak var playareaView: UIView!
    var handSize: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        game.handSize = handSize
        game.deck.shuffle()
        game.deal()
        for card in player.hand.cards {
            render(player: player, card: card, location: handView)
        }
    }
    @IBAction func deckTapped(_ sender: Any) {
        if player.hand.cards.count < 10 {
            player.draw(deck: game.deck)
        }
        if let card = player.hand.cards.last {
            render(player: player, card: card, location: handView)
        }
    }
    func render(player: Player, card: Card, location: UIView) {
        if let index = player.hand.cards.index(of: card) {
            let leftPosition = index * 30
            let image = UIImage(named: card.name + ".png")
            let imageView = UIImageView(image: image!)
            imageView.isAccessibilityElement = true
            imageView.accessibilityIdentifier = card.name
            imageView.frame = CGRect(x: leftPosition, y: 0, width: 90, height: 130)
            location.addSubview(imageView)
            clickCards(imageView: imageView)
        }
    }
    func clickCards(imageView: UIImageView) {
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tap:)))
            imageView.addGestureRecognizer(tap)
            imageView.isUserInteractionEnabled = true
    }
    @objc func imageTapped(tap: UITapGestureRecognizer) {
        let tappedImage = tap.view as! UIImageView
        getCardObject(image: tappedImage)
    }
    func getCardObject(image: UIImageView) {
        player.hand.cards.forEach { card in
            if image.accessibilityIdentifier == card.name {
                moveCardToPlayArea(card: card)
            }
        }
    }
    func moveCardToPlayArea(card: Card) {
        let removedCard = player.hand.remove(card: card)
        playarea.add(card: removedCard)
        print("\(card.name) moved to play area")
    }
    func renderCardInPlayarea() {
        let lastCard = playarea.cards.last
        render(player: player, card: lastCard!, location: playareaView)
    }
}
