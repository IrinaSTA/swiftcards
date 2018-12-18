import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {

    var gameViewController: GameViewController!
    var peerID: MCPeerID!
    var session: MCSession!
    var advertiserAssistant: MCAdvertiserAssistant!

    override func viewDidLoad() {
        super.viewDidLoad()
  
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        gameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController

        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
//        gameViewController.session = self.session
        gameViewController.peerID = self.peerID
        gameViewController.homeViewController = self
        session.delegate = gameViewController
    }

    // MARK: Properties
    @IBOutlet weak var handSizeText: UITextField!

    // MARK: Actions
    @IBAction func showConnectionOptions(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Swiftcards", message: "Do you want to Host or Join this session?", preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Join a session", style: .default, handler: { (action:UIAlertAction) in
            self.advertiserAssistant = MCAdvertiserAssistant(serviceType: "SwiftCards", discoveryInfo: nil, session: self.session)
            self.advertiserAssistant.start()
        }))

        actionSheet.addAction(UIAlertAction(title: "Host a session", style: .default, handler: { (action: UIAlertAction) in
            let browser = MCBrowserViewController(serviceType: "SwiftCards", session: self.session)
            browser.delegate = self
            self.present(browser, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    @IBAction func play(_ sender: UIButton) {
        setupGame()
        let gameMessage = Message(action: "setupGame", game: gameViewController.game)
        let data = encodeMessage(gameMessage)
        sendMessage(data: data)
        self.present(gameViewController, animated: true, completion: nil)
    }
    func setupGame() {
        let newGame = Game(handSize: enteredHandSize(), players: getPlayers(session: self.session))
        newGame.deal()
        gameViewController.setupVariables(game: newGame)
    }
    // Methods or functions
    func enteredHandSize() -> Int {
        let total = Int(handSizeText.text!) ?? 7
        return total
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
             DispatchQueue.main.async {
                do {
                    try self.session.send(data, toPeers: self.session.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
}

struct Message: Codable {
    var action: String
    var game: Game
}

extension ViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
}
