//
//  ViewController.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 10/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

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
        gameViewController.session = self.session
        gameViewController.peerID = self.peerID
        session.delegate = gameViewController
    }

    // MARK: Properties
    @IBOutlet weak var handSizeText: UITextField!

    // MARK: Actions
    @IBAction func showConnectionOptions(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Connection Test", message: "Do you want to Host or Join this session?", preferredStyle: .actionSheet)

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
        self.present(gameViewController, animated: true, completion: nil)
    }
    // Methods or functions
    func enteredHandSize() -> Int {
        let total = Int(handSizeText.text!) ?? 7
        return total
    }
    func setupGame() {
        gameViewController.game = Game(handSize: 5, players: getPlayers(session: self.session))
        gameViewController.game.handSize = enteredHandSize()
        gameViewController.game.deck.shuffle()
        gameViewController.game.deal()
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
}

extension ViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
}
