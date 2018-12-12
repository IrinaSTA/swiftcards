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

    // MARK: Actions
    @IBAction func play(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gameViewController = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        gameViewController.handSize = enteredHandSize()
        self.present(gameViewController, animated: true, completion: nil)
    }
    // Methods or functions
    func enteredHandSize() -> Int {
        let total = Int(handSizeText.text!) ?? 7
        return total
    }
}
