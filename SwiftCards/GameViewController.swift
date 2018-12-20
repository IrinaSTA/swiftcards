import UIKit
import MultipeerConnectivity

class GameViewController: UIViewController {
    @IBOutlet weak var deckImage: UIImageView!
    @IBOutlet weak var handView: UIView!
    @IBOutlet weak var opponentHandView: UIView!
    @IBOutlet weak var playareaView: UIView!

    let multipeer = MultipeerManager.instance
    var game: Game!
    var playarea: Playarea!
    var deck: Deck!
    var players: [Player] = []
    var localPlayer: Player!
    var otherPlayer: Player!
    var renderer: Renderer!

    override func viewDidLoad() {
        super.viewDidLoad()
        renderer = Renderer(viewController: self)
        renderer.renderAll()
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
        renderer.removeCardViewsFromPlayarea()
    }
    @IBAction func deckTapped(_ sender: Any) {
        if localPlayer.hand.cards.count < 13 {
            localPlayer.draw(deck: game.deck)
        }
        renderer.renderAll()
        multipeer.sendUpdateMessage()
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
}
