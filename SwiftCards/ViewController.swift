//
//  ViewController.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 10/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import UIKit

let player = Player()
var game = Game(handSize: 5, players: [player])

class ViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var handSizeText: UITextField!

    // MARK: Actions
    @IBAction func play(_ sender: UIButton) {
        game.handSize = enteredHandSize()
    }
   
    
    // Methods or functions
    func enteredHandSize() -> Int {
        let total = Int(handSizeText.text!) ?? 7
        return total
    }
    
}
