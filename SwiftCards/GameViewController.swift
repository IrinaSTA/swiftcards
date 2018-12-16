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

        // move the card to the playarea if it isn't already there
        if player.hand.cards.contains(touchedCard) {
            player.play(card: touchedCard, location: playarea)
            move(touchedImage, from: handView, to: playareaView)
        }
        
        // bring the card to the front
        playareaView.bringSubview(toFront: touchedImage)

        // update the co-ordinates of the card image
        let translation = drag.translation(in: touchedImage)
        touchedImage.frame.origin.x += translation.x
        touchedImage.frame.origin.y += translation.y
        drag.setTranslation(.zero, in: touchedImage) // resets translation to zero (otherwise it's cumulative)

        // update the model if the gesture has finished
        if drag.state == UIGestureRecognizerState.ended {
            touchedCard.setCoords(x: Float(touchedImage.frame.origin.x), y: Float(touchedImage.frame.origin.y))
            // TODO: send data
        }
    }
    func getCardObject(image: UIImageView) -> Card {
        return Card.find(name: image.accessibilityIdentifier!)
    }
    func move(_ element: UIView, from startingView: UIView, to destinationView: UIView) {
        destinationView.addSubview(element)
        element.frame.origin = startingView.convert(element.frame.origin, to: destinationView)
    }
}
