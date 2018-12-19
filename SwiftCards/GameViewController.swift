import UIKit
import MultipeerConnectivity

class GameViewController: UIViewController {
    @IBOutlet weak var deckImage: UIImageView!
    @IBOutlet weak var handView: UIView!
    @IBOutlet weak var opponentHandView: UIView!
    @IBOutlet weak var playareaView: UIView!

    var setupViewController: SetupViewController!
    var homePageViewController: HomePageViewController!
    var peerID: MCPeerID!
    var game: Game!
    var playarea: Playarea!
    var deck: Deck!
    var players: [Player] = []
    var localPlayer: Player!
    var otherPlayer: Player!

    override func viewDidLoad() {
        super.viewDidLoad()
        displayHands()
    }

    func setupVariables(game: Game) {
        self.game = game
        self.playarea = self.game.playarea
        self.deck = self.game.deck
        self.players = self.game.players
        self.localPlayer = self.players.first(where: {$0.displayName == self.peerID.displayName})!
        if self.players.count > 1 {
             self.otherPlayer = self.players.first(where: {$0.displayName != self.peerID.displayName})!
        }
    }
    func displayHands() {
        if players.count != 1 {
            renderOpponentHand(otherPlayer.hand, location: opponentHandView)
        }
        renderHand(localPlayer.hand, location: handView)
    }
    @IBAction func newGame(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        homePageViewController = storyBoard.instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController
        self.present(homePageViewController, animated: true, completion: nil)
    }
    @IBAction func deckTapped(_ sender: Any) {
        if localPlayer.hand.cards.count < 13 {
            localPlayer.draw(deck: game.deck)
        }
        displayHands()
        sendUpdateMessage()
    }
    @objc func imageTapped(tap: UITapGestureRecognizer) {
        let tappedImage = tap.view as! UIImageView
        let tappedCard = getCardObject(image: tappedImage)
        if localPlayer.hand.cards.contains(tappedCard) {
            localPlayer.play(card: tappedCard, location: playarea)
        } else {
            localPlayer.reclaim(card: tappedCard, from: playarea)
        }
        renderHand(localPlayer.hand, location: handView)
        renderPlayarea(playarea, location: playareaView)
        sendUpdateMessage()
    }
    @objc func imagePressed(press: UILongPressGestureRecognizer) {
        let pressedImage = press.view as! UIImageView
        let pressedCard = getCardObject(image: pressedImage)
        if press.state == UIGestureRecognizerState.began {
            if localPlayer.hand.cards.contains(pressedCard) || playarea.cards.contains(pressedCard) {
                flip(pressedCard)
            }
            renderHand(localPlayer.hand, location: handView)
            renderPlayarea(playarea, location: playareaView)
            sendUpdateMessage()
        }
    }
    func flip(_ card: Card) {
        if card.display == "front" {
            card.faceDown()
        } else {
            card.faceUp()
        }
    }
    @objc func pan(drag: UIPanGestureRecognizer) {
        let touchedImage = drag.view as! UIImageView

        // get new origin
        let translation = drag.translation(in: touchedImage)
        let newX = touchedImage.frame.origin.x + translation.x
        let newY = touchedImage.frame.origin.y + translation.y

        // update model if new position is valid
        let newOrigin = CGPoint(x: newX, y: newY)
        guard validPosition(newOrigin, image: touchedImage) else {
            return
        }

        let touchedCard = getCardObject(image: touchedImage)
        let percentageX = percentage(newX, container: playareaView, dimension: "width")
        let percentageY = percentage(newY, container: playareaView, dimension: "height")
        touchedCard.setCoords(x: percentageX, y: percentageY)
        playarea.bringCardToFront(touchedCard)
        renderPlayarea(playarea, location: playareaView)
        drag.setTranslation(.zero, in: touchedImage)
        sendUpdateMessage()
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
        let drag = UIPanGestureRecognizer(target: self, action: #selector(pan))
        imageView.isUserInteractionEnabled = true
        if !(imageView.gestureRecognizers!.contains {$0 is UIPanGestureRecognizer}) {
            imageView.addGestureRecognizer(drag)
        }
    }

    func removeDraggable(imageView: UIImageView) {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(pan))
        if imageView.gestureRecognizers!.contains(drag) {
            imageView.removeGestureRecognizer(drag)
        }
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
            let leftPosition = Float(hand.cards.index(of: card)! * 6)
            card.setCoords(x: leftPosition, y: 0.0)
            render(card, location: location)
            if location == opponentHandView {
                showOpponent(imageView(card))
            }
        }
    }
    func renderOpponentHand(_ hand: Hand, location: UIView) {
        for card in hand.cards {
            let leftPosition = Float(hand.cards.index(of: card)!) * 4.5
            card.setCoords(x: leftPosition, y: 0.0)
            render(card, location: location)
            showOpponent(imageView(card))
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
    func renderPlayarea(_ playarea: Playarea, location: UIView) {
        for card in playarea.cards {
            render(card, location: playareaView)
        }
    }
    func render(_ card: Card, location: UIView) {
        var cardView = UIImageView()
        cardView = imageView(card)
        if card.display == "front" {
            showFront(cardView)
        } else if card.display == "back" {
            showBack(cardView)
        }
        location.addSubview(cardView)
        let xPosition = absolute(card.xPosition, container: location.superview!, dimension: "width")
        let yPosition = absolute(card.yPosition, container: location, dimension: "height")
        cardView.frame.origin = CGPoint(x: xPosition, y: yPosition)
        if location == playareaView {
            makeDraggable(imageView: cardView)
        } else {
            removeDraggable(imageView: cardView)
        }
    }
    func imageView(_ card: Card) -> UIImageView {
        let allViews = playareaView.subviews + handView.subviews + opponentHandView.subviews
        if let existingView = allViews.first(where: {$0.accessibilityIdentifier == card.name}) {
            return existingView as! UIImageView
        } else {
            let image = UIImage(named: card.name + ".png")
            let imageView = UIImageView(image: image!)
            imageView.isAccessibilityElement = true
            imageView.accessibilityIdentifier = card.name
            let cardWidth = absolute(20.0, container: handView.superview!, dimension: "width") // uses superview width because handView and playareaView widths are unreliable for some reason
            let cardHeight = cardWidth * 1.4
            imageView.frame = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)
            makeSingleTappable(imageView: imageView)
            makePressable(imageView: imageView)
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
        return game.find(name: image.accessibilityIdentifier!)
    }
    func renderAll() {
        displayHands()
        renderPlayarea(playarea, location: playareaView)
    }
    func sendUpdateMessage() {
        let gameMessage = Message(action: "updateGame", game: self.game)
        let data = setupViewController.encodeMessage(gameMessage)
        setupViewController.sendMessage(data: data)
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
        DispatchQueue.main.async {
            do {
                let decodedMessage = try JSONDecoder().decode(Message.self, from: data)
                let decodedGame = decodedMessage.game
                self.setupVariables(game: decodedGame)
                if decodedMessage.action == "setupGame" {
                    self.homePageViewController.present(self, animated: true, completion: nil)
                } else if decodedMessage.action == "updateGame" {
                    self.renderAll()
                }
            } catch {
                print("Failed to decode message!")
            }
        }
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}
