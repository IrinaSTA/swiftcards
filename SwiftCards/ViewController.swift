//
//  ViewController.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 10/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import UIKit

var handSize: Int = 5

class ViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var handSizeText: UITextField!
    @IBOutlet weak var deckImage: UIImageView!
    @IBOutlet var gamePage: UIView!
    @IBOutlet weak var handView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: Actions
    @IBAction func deckTapped(_ sender: Any) {
        print("deck tapped")
        let deck = Deck()
        let hand = Hand()
        let newCard = deck.removeTopCard()
        hand.add(card: newCard)
    }
    @IBAction func play(_ sender: UIButton) {
        handSize = convertStringToInteger()
    }
    @IBAction func load(_ sender: UIButton) {
        let player = Player()
        let game = Game(handSize: handSize, players: [player])
        let image = UIImage(named: game.deck.cards[0].name + ".png")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 50, y: 50, width: 100, height: 200)
        handView.addSubview(imageView)
    }
    @IBAction func returnKeyPressed(_ sender: Any) {
    }
    // Methods or functions
    func convertStringToInteger() -> Int {
        let total = Int(handSizeText.text!) ?? 7
        return total
    }
}

