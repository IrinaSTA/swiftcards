import UIKit
import MultipeerConnectivity

class GameViewController: UIViewController {
    @IBOutlet weak var deckImage: UIImageView!
    @IBOutlet weak var handView: UIView!
    @IBOutlet weak var opponentHandView: UIView!
    @IBOutlet weak var playareaView: UIView!

    var game: Game!
    var playarea: Playarea!
    var deck: Deck!
    var players: [Player] = []
    var localPlayer: Player!
    var otherPlayer: Player!
    let multipeer = MultipeerManager.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        renderAll()
    }
    @IBAction func newGame(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        Controllers.home = storyBoard.instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController
        self.present(Controllers.home, animated: true, completion: nil)
    }
    @IBAction func restackDeck(_ sender: Any) {
        for card in playarea.cards {
            let removedCard = playarea.remove(card: card)
            deck.cards.append(removedCard)
        }
        deck.shuffle()
        removeCardViewsFromPlayarea()
    }
    @IBAction func deckTapped(_ sender: Any) {
        if localPlayer.hand.cards.count < 13 {
            localPlayer.draw(deck: game.deck)
        }
        renderAll()
        sendUpdateMessage()
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
        renderAll()
        sendUpdateMessage()
    }
    @objc func imagePressed(press: UILongPressGestureRecognizer) {
        let pressedImage = press.view as! UIImageView
        let pressedCard = getCardObject(image: pressedImage)
        guard press.state == UIGestureRecognizerState.began else {
            return
        }
        if localPlayer.hand.cards.contains(pressedCard) || playarea.cards.contains(pressedCard) {
            pressedCard.flip()
            renderAll()
            sendUpdateMessage()
        }
    }
    @objc func imageDragged(drag: UIPanGestureRecognizer) {
        let cardView = drag.view as! UIImageView
        let card = getCardObject(image: cardView)
        let translation = drag.translation(in: cardView)
        drag.setTranslation(.zero, in: cardView)
        let nextPosition = newPosition(cardView: cardView, translation: translation)
        setPosition(card, nextPosition, location: playareaView)
        playarea.bringCardToFront(card) // needed to preserve order of card stacking
        renderPlayarea(playarea, location: playareaView)
        sendUpdateMessage()
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
        let absolutePosition = playareaView.convert(position, to: nil)
        var candidateFrame = image.frame
        candidateFrame.origin = absolutePosition
        if playareaView.frame.contains(candidateFrame) {
            return true
        } else {
            return false
        }
    }
    func setPosition(_ card: Card, _ point: CGPoint, location: UIView) {
        let percentageX = percentage(point.x, container: location, dimension: "width")
        let percentageY = percentage(point.y, container: location, dimension: "height")
        card.setCoords(x: percentageX, y: percentageY)
        
    }
    func setupVariables(game: Game) {
        self.game = game
        self.playarea = self.game.playarea
        self.deck = self.game.deck
        self.players = self.game.players
        self.localPlayer = self.players.first(where: {$0.displayName == multipeer.peerID.displayName})!
        if self.players.count > 1 {
            self.otherPlayer = self.players.first(where: {$0.displayName != multipeer.peerID.displayName})!
        }
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


    
    
    
    
    func render(_ card: Card, location: UIView) {
        let cardView = imageView(card)
        showCorrectSide(cardView)
        location.addSubview(cardView)
        cardView.frame.origin = getPosition(card, location: location)
    }
    func imageView(_ card: Card) -> UIImageView {
        let allViews = playareaView.subviews + handView.subviews + opponentHandView.subviews
        if let preexistingView = allViews.first(where: {$0.accessibilityIdentifier == card.name}) {
            return preexistingView as! UIImageView
        } else {
            return makeNewImageView(card)
        }
    }
    func makeNewImageView(_ card: Card) -> UIImageView {
        let image = UIImage(named: card.name + ".png")
        let cardView = UIImageView(image: image!)
        setDimensions(cardView: cardView)
        addInteractivity(cardView: cardView, card: card)
        return cardView
    }
    func setDimensions(cardView: UIImageView) {
        let ASPECT_RATIO = 1.4
        let CARD_WIDTH_PERCENTAGE = Float(20)
        let cardWidth = absolute(CARD_WIDTH_PERCENTAGE, container: handView.superview!, dimension: "width") // uses superview width because handView and playareaView widths are unreliable for some reason
        let cardHeight = cardWidth * CGFloat(ASPECT_RATIO)
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
    func renderPlayarea(_ playarea: Playarea, location: UIView) {
        for card in playarea.cards {
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
        positionHand(hand, spacing: 6.0)
        for card in hand.cards {
            render(card, location: location)
        }
    }
    func renderOpponentHand(_ hand: Hand, location: UIView) {
        positionHand(hand, spacing: 4.5)
        for card in hand.cards {
            render(card, location: location)
            showOpponent(imageView(card))
        }
    }
    func renderAll() {
        renderHand(localPlayer.hand, location: handView)
        if players.count != 1 {
            renderOpponentHand(otherPlayer.hand, location: opponentHandView)
        }
        renderPlayarea(playarea, location: playareaView)
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
    
    
    func getCardObject(image: UIImageView) -> Card {
        return game.find(name: image.accessibilityIdentifier!)
    }
    func removeCardViewsFromPlayarea() {
        for view in playareaView.subviews {
            view.removeFromSuperview()
        }
    }
    func sendUpdateMessage() {
        let gameMessage = Message(action: "updateGame", game: self.game)
        let data = multipeer.encodeMessage(gameMessage)
        multipeer.sendMessage(data: data)
    }
}
