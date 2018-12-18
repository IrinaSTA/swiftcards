import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {

    var gameViewController: GameViewController!
    var peerID: MCPeerID!
    var session: MCSession!

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        gameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController

//        peerID = MCPeerID(displayName: UIDevice.current.name)
//        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
//        gameViewController.session = self.session
        gameViewController.peerID = self.peerID
        gameViewController.homeViewController = self
        session.delegate = gameViewController
    }

    @IBOutlet weak var handSizeText: UITextField!

    @IBAction func play(_ sender: UIButton) {
        setupGame()
        var gameMessage = Message(action: "setupGame", game: gameViewController.game)
        var data = encodeMessage(gameMessage)
        sendMessage(data: data)
        self.present(gameViewController, animated: true, completion: nil)
    }
    func setupGame() {
        let newGame = Game(handSize: enteredHandSize(), players: getPlayers(session: self.session))
        newGame.deck.shuffle()
        newGame.deal()
        gameViewController.setupVariables(game: newGame)
    }
    func getPlayers(session: MCSession) -> [Player] {
        var players: [Player] = []
        for peerID in session.connectedPeers {
            players.append(Player(peerID: peerID))
        }
        gameViewController.localPlayer = Player(peerID: self.peerID)
        players.append(gameViewController.localPlayer)
        return players
    }
    func enteredHandSize() -> Int {
        let total = Int(handSizeText.text!) ?? 7
        return total
    }

    func encodeMessage(_ message: Message) -> Data {
        var data: Data!
        do {
            data = try JSONEncoder().encode(message)
        } catch {
            print("Object could not be encoded!")
        }
        return data
    }
    func sendMessage(data: Data) {
        if session.connectedPeers.count > 0 {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch let error as NSError {
                print(error)
            }
        }
    }
}

struct Message: Codable {
    var action: String
    var game: Game
}
