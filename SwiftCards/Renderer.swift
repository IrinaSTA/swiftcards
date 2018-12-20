//
//  Renderer.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 20/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import Foundation
import UIKit

class Renderer {
    let CARD_ASPECT_RATIO: Float
    let CARD_WIDTH_PERCENTAGE: Float
    let LOCAL_HAND_SPACING: Float
    let OPPONENT_HAND_SPACING: Float
    let viewController: GameViewController!
    init(viewController: GameViewController) {
        CARD_ASPECT_RATIO = Float(1.4)
        CARD_WIDTH_PERCENTAGE = Float(20)
        LOCAL_HAND_SPACING = CARD_WIDTH_PERCENTAGE / 3
        OPPONENT_HAND_SPACING = CARD_WIDTH_PERCENTAGE / 4
        self.viewController = viewController
    }
    func render(_ card: Card, location: UIView) {
        let cardView = getImageView(card)
        showCorrectSide(cardView)
        location.addSubview(cardView)
        cardView.frame.origin = getPosition(card, location: location)
    }
    func getImageView(_ card: Card) -> UIImageView {
        let allViews = viewController.playareaView.subviews + viewController.handView.subviews + viewController.opponentHandView.subviews
        if let preexistingView = allViews.first(where: {$0.accessibilityIdentifier == card.name}) {
            return preexistingView as! UIImageView
        } else {
            return makeNewImageView(card)
        }
    }
    func makeNewImageView(_ card: Card) -> UIImageView {
        let image = UIImage(named: card.name + ".png")
        let cardView = UIImageView(image: image!)
        setDimensions(cardView: cardView, referenceContainer: viewController.view)
        addInteractivity(cardView: cardView, card: card)
        return cardView
    }
    func setDimensions(cardView: UIImageView, referenceContainer: UIView) {
        let cardWidth = absolute(CARD_WIDTH_PERCENTAGE, container: referenceContainer, dimension: "width")
        let cardHeight = cardWidth * CGFloat(CARD_ASPECT_RATIO)
        cardView.frame = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)
    }
    func addInteractivity(cardView: UIImageView, card: Card) {
        cardView.isAccessibilityElement = true
        cardView.accessibilityIdentifier = card.name
        makeSingleTappable(imageView: cardView)
        makePressable(imageView: cardView)
    }
    func showCorrectSide(_ cardView: UIImageView) {
        let card = getCardObject(image: cardView)
        if card.display == "front" {
            showFront(cardView)
        } else if card.display == "back" {
            showBack(cardView)
        }
    }
    func showFront(_ cardView: UIImageView) {
        cardView.image = UIImage(named: cardView.accessibilityIdentifier! + ".png")
    }
    func showBack(_ cardView: UIImageView) {
        cardView.image = UIImage(named: "backOfCard.png")
    }
    func showOpponent(_ cardView: UIImageView) {
        cardView.image = UIImage(named: "otherPlayerCard.png")
    }
    func getPosition(_ card: Card, location: UIView) -> CGPoint {
        let xPosition = absolute(card.xPosition, container: location.superview!, dimension: "width") // uses superview because handView and playareaView start off with wrong width for some reason!
        let yPosition = absolute(card.yPosition, container: location, dimension: "height")
        return CGPoint(x: xPosition, y: yPosition)
    }
    func setPosition(_ card: Card, _ point: CGPoint, location: UIView) {
        let percentageX = percentage(point.x, container: location, dimension: "width")
        let percentageY = percentage(point.y, container: location, dimension: "height")
        card.setCoords(x: percentageX, y: percentageY)
    }
    func renderPlayarea(_ playarea: Playarea, location: UIView) {
        for card in playarea.cards {
            makeDraggable(imageView: getImageView(card))
            render(card, location: location)
        }
    }
    func positionHand(_ hand: Hand, spacing: Float) {
        for card in hand.cards {
            let leftPosition = Float(hand.cards.index(of: card)!) * spacing
            card.setCoords(x: leftPosition, y: 0.0)
        }
    }
    func renderHand(_ hand: Hand, location: UIView) {
        positionHand(hand, spacing: LOCAL_HAND_SPACING)
        for card in hand.cards {
            render(card, location: location)
        }
    }
    func renderOpponentHand(_ hand: Hand, location: UIView) {
        positionHand(hand, spacing: OPPONENT_HAND_SPACING)
        for card in hand.cards {
            render(card, location: location)
            removeDraggable(imageView: getImageView(card))
            showOpponent(getImageView(card))
        }
    }
    func renderAll() {
        renderHand(viewController.localPlayer.hand, location: viewController.handView)
        if viewController.players.count >= 1 {
            renderOpponentHand(viewController.otherPlayer.hand, location: viewController.opponentHandView)
        }
        renderPlayarea(viewController.playarea, location: viewController.playareaView)
    }
    func percentage(_ coordinate: CGFloat, container: UIView, dimension: String) -> Float {
        var max: CGFloat
        if dimension == "width" {
            max = container.bounds.width
        } else {
            max = container.bounds.height
        }
        return Float((coordinate / max) * 100)
    }
    func absolute(_ coordinate: Float, container: UIView, dimension: String) -> CGFloat {
        var max: Float
        if dimension == "width" {
            max = Float(container.bounds.width)
        } else {
            max = Float(container.bounds.height)
        }
        return CGFloat((coordinate / 100) * max)
    }
    func makeSingleTappable(imageView: UIImageView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tap:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    func makePressable(imageView: UIImageView) {
        let press = UILongPressGestureRecognizer(target: self, action: #selector(imagePressed(press:)))
        imageView.isUserInteractionEnabled = true
        press.minimumPressDuration = 0.5
        imageView.addGestureRecognizer(press)
    }
    func makeDraggable(imageView: UIImageView) {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(imageDragged))
        imageView.isUserInteractionEnabled = true
        if !(imageView.gestureRecognizers!.contains {$0 is UIPanGestureRecognizer}) {
            imageView.addGestureRecognizer(drag)
        }
    }
    func removeDraggable(imageView: UIImageView) {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(imageDragged))
        if imageView.gestureRecognizers!.contains(drag) {
            imageView.removeGestureRecognizer(drag)
        }
    }
    func getCardObject(image: UIImageView) -> Card {
        return viewController.game.find(name: image.accessibilityIdentifier!)
    }
    func removeCardViewsFromPlayarea() {
        for view in viewController.playareaView.subviews {
            view.removeFromSuperview()
        }
    }
    func newPosition(cardView: UIImageView, translation: CGPoint) -> CGPoint {
        let newX = cardView.frame.origin.x + translation.x
        let newY = cardView.frame.origin.y + translation.y
        let candidatePosition = CGPoint(x: newX, y: newY)
        if isValidPosition(candidatePosition, image: cardView) {
            return candidatePosition
        } else {
            return cardView.frame.origin
        }
    }
    func isValidPosition(_ position: CGPoint, image: UIImageView) -> Bool {
        let absolutePosition = viewController.playareaView.convert(position, to: nil)
        var candidateFrame = image.frame
        candidateFrame.origin = absolutePosition
        if viewController.playareaView.frame.contains(candidateFrame) {
            return true
        } else {
            return false
        }
    }
    @objc func imageTapped(tap: UITapGestureRecognizer) {
        let tappedImage = tap.view as! UIImageView
        let tappedCard = getCardObject(image: tappedImage)
        let localHand = viewController.localPlayer.hand.cards
        if localHand.contains(tappedCard) {
            viewController.localPlayer.play(card: tappedCard, location: viewController.playarea)
        } else {
            viewController.localPlayer.reclaim(card: tappedCard, from: viewController.playarea)
        }
        renderAll()
        viewController.multipeer.sendUpdateMessage()
    }
    @objc func imagePressed(press: UILongPressGestureRecognizer) {
        let pressedImage = press.view as! UIImageView
        let pressedCard = getCardObject(image: pressedImage)
        guard press.state == UIGestureRecognizerState.began else {
            return
        }
        let visibleCards = viewController.localPlayer.hand.cards + viewController.playarea.cards
        if visibleCards.contains(pressedCard) {
            pressedCard.flip()
            renderAll()
            viewController.multipeer.sendUpdateMessage()
        }
    }
    @objc func imageDragged(drag: UIPanGestureRecognizer) {
        let cardView = drag.view as! UIImageView
        let card = getCardObject(image: cardView)
        let translation = drag.translation(in: cardView)
        drag.setTranslation(.zero, in: cardView)
        let nextPosition = newPosition(cardView: cardView, translation: translation)
        setPosition(card, nextPosition, location: viewController.playareaView)
        viewController.playarea.bringCardToFront(card) // needed to preserve order of card stacking
        renderPlayarea(viewController.playarea, location: viewController.playareaView)
        viewController.multipeer.sendUpdateMessage()
    }
}
