//
//  ViewController.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 10/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import UIKit

//var handSize: Int = 5
let player = Player()
var game = Game(handSize: 5, players: [player])

class ViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var handSizeText: UITextField!
    @IBOutlet weak var deckImage: UIImageView!
    @IBOutlet var gamePage: UIView!
    @IBOutlet weak var handView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: Actions
    @IBAction func deckTapped(_ sender: Any) {
        if player.hand.cards.count < 10 {
            player.draw(deck: game.deck)
        }
        if let card = player.hand.cards.last {
            let image = UIImage(named: card.name + ".png")
            let imageView = UIImageView(image: image!)
            let leftPosition = (player.hand.cards.count - 1) * 30
            imageView.frame = CGRect(x: leftPosition, y: 0, width: 90, height: 130)
            handView.addSubview(imageView)
        }
    }
    @IBAction func play(_ sender: UIButton) {
        game.handSize = convertStringToInteger()
    }
    @IBAction func load(_ sender: UIButton) {
        game.deck.shuffle()
        game.deal()
        let image = UIImage(named: game.deck.cards[0].name + ".png")
        let imageView = UIImageView(image: image!)
        var leftPosition = 0
        print(player.hand.cards)
        for card in player.hand.cards {
            let image = UIImage(named: card.name + ".png")
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: leftPosition, y: 0, width: 90, height: 130)
            handView.addSubview(imageView)
            leftPosition += 30
        }

    }
    @IBAction func returnKeyPressed(_ sender: Any) {
    }
    // Methods or functions
    func convertStringToInteger() -> Int {
        let total = Int(handSizeText.text!) ?? 7
        return total
    }
}
