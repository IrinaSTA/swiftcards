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
            makeDraggable(imageView: imageView)
        }
    }
    func makeDraggable(imageView: UIImageView) {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(pan))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(drag)
    }
    @objc func pan(drag: UIPanGestureRecognizer) {
        let touchedImage = drag.view as! UIImageView
        let touchedCard = getCardObject(image: touchedImage)
        let translation = drag.translation(in: touchedImage)
        let newX = touchedImage.center.x + translation.x
        let newY = touchedImage.center.y + translation.y
        touchedCard.setCoords(x: Float(newX), y: Float(newY))
        touchedImage.center.x = newX
        touchedImage.center.y = newY
        drag.setTranslation(.zero, in: touchedImage)
        playareaView.addSubview(touchedImage)
        if player.hand.cards.contains(touchedCard) {
            player.play(card: touchedCard, location: playarea)
        }
    }
    func getCardObject(image: UIImageView) -> Card {
        return Card.find(name: image.accessibilityIdentifier!)
    }
}
