//
//  ViewController.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 10/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import UIKit

var handSize: Int = 5
let deck = Deck()
let player = Player()

class ViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var handSizeText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: Actions
   
    @IBAction func play(_ sender: UIButton) {
        handSize = convertStringToInteger()
    }
  
    @IBAction func returnKeyPressed(_ sender: Any) {
    }
    // Methods or functions
    func convertStringToInteger() -> Int {
        let total = Int(handSizeText.text!) ?? 7
        return total
    }
}
