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
        renderHand(player.hand, location: handView)
//        for card in player.hand.cards {
//            render(player: player, card: card, location: handView)
//        }
    }
    @IBAction func deckTapped(_ sender: Any) {
        if player.hand.cards.count < 10 {
            player.draw(deck: game.deck)
        }
        renderHand(player.hand, location: handView)
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
            makeTappable(imageView: imageView)
        }
    }
    
    func makeTappable(imageView: UIImageView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tap:)))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
    }
    
    func makeDraggable(imageView: UIImageView) {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(pan))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(drag)
    }
    
    @objc func imageTapped(tap: UITapGestureRecognizer) {
        let tappedImage = tap.view as! UIImageView
        let tappedCard = getCardObject(image: tappedImage)
        if player.hand.cards.contains(tappedCard) {
            player.play(card: tappedCard, location: playarea)
            move(tappedImage, from: handView, to: playareaView)
            tappedImage.frame.origin = CGPoint(x: 0, y: 0)
        } else {
            player.reclaim(card: tappedCard, from: playarea)
            move(tappedImage, from: playareaView, to: handView)
            let leftPosition = player.hand.cards.index(of: tappedCard)! * 30
            tappedImage.frame.origin = CGPoint(x: leftPosition, y: 0)
        }
        makeDraggable(imageView: tappedImage)
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
        let newX = touchedImage.frame.origin.x + translation.x
        let newY = touchedImage.frame.origin.y + translation.y
        let newOrigin = CGPoint(x: newX, y: newY)
        var newFrame = touchedImage.frame
        let newOriginAbsolute = playareaView.convert(newOrigin, to: nil)
        newFrame.origin = newOriginAbsolute
        if playareaView.frame.contains(newFrame) {
            touchedImage.frame.origin = newOrigin
        }
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
    func imageView(_ card: Card) -> UIImageView {
        let image = UIImage(named: card.name + ".png")
        let imageView = UIImageView(image: image!)
        imageView.isAccessibilityElement = true
        imageView.accessibilityIdentifier = card.name
        imageView.frame = CGRect(x: 0, y: 0, width: 90, height: 130)
        return imageView
    }
    func renderHand(_ hand: Hand, location: UIView) {
        for card in hand.cards {
            let cardView = imageView(card)
            let leftPosition = hand.cards.index(of: card)! * 30
            handView.addSubview(cardView)
            cardView.frame.origin.x = CGFloat(leftPosition)
            makeTappable(imageView: cardView)
        }
    }

}
