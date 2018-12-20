//
//  MultipeerManager.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 19/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class MultipeerManager: NSObject, MCSessionDelegate {
    static let instance = MultipeerManager()
    var peerID: MCPeerID!
    var session: MCSession!
    var advertiserAssistant: MCAdvertiserAssistant!
    var browser: MCBrowserViewController!
    override init() {
        super.init()
        resetConnectivity()
    }
    func resetConnectivity() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        advertiserAssistant = MCAdvertiserAssistant(serviceType: "SwiftCards", discoveryInfo: nil, session: session)
        browser = MCBrowserViewController(serviceType: "SwiftCards", session: session)
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
    func sendSetupMessage() {
        let game = Controllers.game.game!
        let message = Message(action: "setupGame", game: game)
        let data = encodeMessage(message)
        send(data: data)
    }
    func sendUpdateMessage() {
        let game = Controllers.game.game!
        let message = Message(action: "updateGame", game: game)
        let data = encodeMessage(message)
        send(data: data)
    }
    func sendRestackDeckMessage() {
        let game = Controllers.game.game!
        let message = Message(action: "restackDeck", game: game)
        let data = encodeMessage(message)
        send(data: data)
    }
    func send(data: Data) {
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
    func processMessage(_ data: Data) {
        do {
            let decodedMessage = try JSONDecoder().decode(Message.self, from: data)
            let decodedGame = decodedMessage.game
            Controllers.game.setupVariables(game: decodedGame)
            if decodedMessage.action == "setupGame" {
                Controllers.joiner.present(Controllers.game, animated: true, completion: nil)
            } else if decodedMessage.action == "updateGame" {
                Controllers.game.renderer.renderAll()
            } else if decodedMessage.action == "restackDeck" {
                Controllers.game.renderer.removeCardViewsFromPlayarea()
            }
        } catch {
            print("Failed to decode message!")
        }
    }
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
            print("MESSAGE RECEIVED")
            self.processMessage(data)
        }
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }

}
