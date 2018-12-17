//
//  GameViewController.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 12/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class GameViewController: UIViewController {
    @IBOutlet weak var deckImage: UIImageView!
    @IBOutlet weak var handView: UIScrollView!
    @IBOutlet weak var playareaView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var opponentHandView: UIView!
    var homeViewController: ViewController!
    var handSize: Int = 5
    var session: MCSession!
    var peerID: MCPeerID!
    var localPlayer: Player!
    var game: Game!
    var playarea: Playarea!
    var deck: Deck!
    var players: [Player] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // convenience variables
        playarea = game.playarea
        deck = game.deck
        players = game.players

        // TODO: delete this
        for player in players {
            print(player.displayName)
        }

        // render hand
        displayHands()
    }

    func displayHands() {
        if players.count != 1 {
            renderHand(localPlayer.hand, location: opponentHandView)
        }
        renderHand(localPlayer.hand, location: handView)
    }
    @IBAction func newGame(_ sender: Any) {
        game.reset()
    }
    @IBAction func deckTapped(_ sender: Any) {
        if localPlayer.hand.cards.count < 50 {
            localPlayer.draw(deck: game.deck)
        }
        displayHands()
        // TODO: delete this code

        let string = "HELLO"
        let data = string.data(using: .utf8)
        if session.connectedPeers.count > 0 {
            do {
                try session.send(data!, toPeers: session.connectedPeers, with: .reliable)
            } catch let error as NSError {
                print(error)
            }
        }
    }
    @objc func imageTapped(tap: UITapGestureRecognizer) {
        let tappedImage = tap.view as! UIImageView
        let tappedCard = getCardObject(image: tappedImage)
        if localPlayer.hand.cards.contains(tappedCard) {
            localPlayer.play(card: tappedCard, location: playarea)
            makeDraggable(imageView: tappedImage)
        } else {
            localPlayer.reclaim(card: tappedCard, from: playarea)
            removeDraggable(imageView: tappedImage)
        }
        renderHand(localPlayer.hand, location: handView)
        renderPlayarea(playarea, location: playareaView)
    }
    @objc func pan(drag: UIPanGestureRecognizer) {
        let touchedImage = drag.view as! UIImageView

        // get new origin
        let translation = drag.translation(in: touchedImage)
        let newX = touchedImage.frame.origin.x + translation.x
        let newY = touchedImage.frame.origin.y + translation.y

        // update model if new position is valid
        let newOrigin = CGPoint(x: newX, y: newY)
        if validPosition(newOrigin, image: touchedImage) {
            let touchedCard = getCardObject(image: touchedImage)
            touchedCard.setCoords(x: Float(newX), y: Float(newY))
        }

        // update the view from the model
        renderPlayarea(playarea, location: playareaView)

        // bring card to front
        playareaView.bringSubview(toFront: touchedImage)

        // reset translation to zero (otherwise it's cumulative)
        drag.setTranslation(.zero, in: touchedImage)

        // send data when the gesture has finished
        if drag.state == UIGestureRecognizerState.ended {
            // TODO: send data
        }
    }

    func makeTappable(imageView: UIImageView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tap:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }

    func makeDraggable(imageView: UIImageView) {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(pan))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(drag)
    }

    func removeDraggable(imageView: UIImageView) {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(pan))
        imageView.removeGestureRecognizer(drag)
    }

    func validPosition(_ position: CGPoint, image: UIImageView) -> Bool {
        var newFrame = image.frame
        let absolutePosition = playareaView.convert(position, to: nil)
        newFrame.origin = absolutePosition
        if playareaView.frame.contains(newFrame) {
            return true
        } else {
            return false
        }
    }
    func renderHand(_ hand: Hand, location: UIView) {
        for card in hand.cards {
            let leftPosition = Float(hand.cards.index(of: card)! * 30)
            card.setCoords(x: leftPosition, y: 0.0)
            render(card, location: location)
        }
    }
    func renderPlayarea(_ playarea: Playarea, location: UIView) {
        for card in playarea.cards {
            render(card, location: playareaView)
        }
    }
    func render(_ card: Card, location: UIView) {
        var cardView = UIImageView()
        if location == opponentHandView {
            cardView = makeOpponentView(card)
        } else {
            cardView = makeImageView(card)
        }
        location.addSubview(cardView)
        let xPosition = CGFloat(card.xPosition)
        let yPosition = CGFloat(card.yPosition)
        cardView.frame.origin = CGPoint(x: xPosition, y: yPosition)
    }
    func makeImageView(_ card: Card) -> UIImageView {
        let allViews = playareaView.subviews + handView.subviews
        if let existingView = allViews.first(where: {$0.accessibilityIdentifier == card.name}) {
            return existingView as! UIImageView
        } else {
            let image = UIImage(named: card.name + ".png")
            let imageView = UIImageView(image: image!)
            imageView.isAccessibilityElement = true
            imageView.accessibilityIdentifier = card.name
            imageView.frame = CGRect(x: 0, y: 0, width: 90, height: 130)
            makeTappable(imageView: imageView)
            return imageView
        }
    }
    func makeOpponentView(_ card: Card) -> UIImageView {
        let image = UIImage(named: "backOfCard.png")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: 90, height: 130)
        return imageView
    }
    func getCardObject(image: UIImageView) -> Card {
        return Card.find(name: image.accessibilityIdentifier!)
    }
}

extension GameViewController: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("OOOOOOOO")
        do {
            let decodedMessage = try JSONDecoder().decode(Message<Game>.self, from: data)
            let decodedGame = decodedMessage.object
            self.game = decodedGame
            self.localPlayer = game.players.first(where: {$0.displayName == self.peerID.displayName})!
            homeViewController.present(self, animated: true, completion: nil)
        } catch {
            print("Failed to decode message!")
        }
        print("OOOOOOOO")
//        let string = String(decoding: data, as: UTF8.self)
//        DispatchQueue.main.async {
//            self.textField.text = string
//        }
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}
