//
//  ViewController.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 10/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var handSizeText: UITextField!
    @IBOutlet weak var deckImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: Actions
    @IBAction func deckTapped(_ sender: Any) {
        print("deck tapped")
    }
    @IBAction func play(_ sender: UIButton) {
        let handSize = convertStringToInteger()
        let player = Player()
        let game = Game(handSize: handSize, players: [player])
        let image = UIImage(named: game.deck.cards[0].name + ".png")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 50, y: 50, width: 100, height: 200)
        self.view.addSubview(imageView)
    }
    @IBAction func returnKeyPressed(_ sender: Any) {
    }
    // Methods or functions
    func convertStringToInteger() -> Int {
        let total = Int(handSizeText.text!) ?? 5
        return total
    }
}

