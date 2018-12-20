import UIKit
import MultipeerConnectivity

class SetupViewController: UIViewController, UITextFieldDelegate {
    let multipeer = MultipeerManager.instance
    let DEFAULT_HAND_SIZE = 7

    override func viewDidLoad() {
        super.viewDidLoad()
        handSizeText.delegate = self
    }
    @IBOutlet weak var handSizeText: UITextField!
    @IBOutlet weak var toggleFaceDownSwitch: UISwitch!
    @IBAction func play(_ sender: UIButton) {
        setupGame()
        self.present(Controllers.game, animated: true, completion: nil)
        multipeer.sendSetupMessage()
    }

    func setupGame() {
        let newGame = Game(handSize: enteredHandSize(), players: getPlayers(session: multipeer.session))
        if toggleFaceDownSwitch.isOn {
            faceDownDeck(newGame.deck)
        }
        newGame.deck.shuffle()
        newGame.deal()
        Controllers.game.setupVariables(game: newGame)
    }
    func faceDownDeck(_ deck: Deck) {
        for card in deck.cards {
            card.faceDown()
        }
    }
    func getPlayers(session: MCSession) -> [Player] {
        var players: [Player] = []
        for peerID in session.connectedPeers {
            players.append(Player(peerID: peerID))
        }
        players.append(Player(peerID: multipeer.peerID))
        return players
    }
    func enteredHandSize() -> Int {
        return Int(handSizeText.text!) ?? DEFAULT_HAND_SIZE
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handSizeText.resignFirstResponder()
        return true
    }
}

struct Message: Codable {
    var action: String
    var game: Game
}
