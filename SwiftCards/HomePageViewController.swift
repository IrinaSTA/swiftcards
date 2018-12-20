import UIKit
import MultipeerConnectivity

class HomePageViewController: UIViewController {
    var advertiserAssistant: MCAdvertiserAssistant!
    var session: MCSession!
    var peerID: MCPeerID!
    var setupViewController: SetupViewController!
    var gameViewController: GameViewController!
    var joinerViewController: JoinerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        setupViewController = storyBoard.instantiateViewController(withIdentifier: "SetupViewController") as? SetupViewController
        setupViewController.session = self.session
        setupViewController.peerID = peerID
        gameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
        gameViewController.homePageViewController = self
        gameViewController.peerID = peerID
        session.delegate = gameViewController
        gameViewController.setupViewController = setupViewController
        setupViewController.gameViewController = gameViewController
        joinerViewController = storyBoard.instantiateViewController(withIdentifier: "JoinerViewController") as? JoinerViewController
        gameViewController.joinerViewController = joinerViewController
    }

    @IBAction func showConnectionOptions(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Swiftcards", message: "Do you want to Host or Join this session?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Join a session", style: .default, handler: { (action:UIAlertAction) in
            self.advertiserAssistant = MCAdvertiserAssistant(serviceType: "SwiftCards", discoveryInfo: nil, session: self.session)
            self.advertiserAssistant.start()
            self.present(self.joinerViewController, animated: true, completion: nil)
        }))

        actionSheet.addAction(UIAlertAction(title: "Host a session", style: .default, handler: { (action: UIAlertAction) in
            let browser = MCBrowserViewController(serviceType: "SwiftCards", session: self.session)
            browser.delegate = self
            self.present(browser, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // makes it work on an iPad
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func setupSinglePlayerGame(_ sender: UIButton) {
        self.present(setupViewController, animated: true, completion: nil)
    }
}

extension HomePageViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
        self.present(setupViewController, animated: true, completion: nil)
    }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
}
