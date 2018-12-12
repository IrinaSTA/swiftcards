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
        convertStringToInteger()
    }
    @IBAction func returnKeyPressed(_ sender: Any) {
    }
    // Methods or functions
    func convertStringToInteger() {
        guard let total = Int(handSizeText.text!) else {
            print("Not a number: \(handSizeText.text!)")
            return
        }
        print("The total number of cards is \(total)")
    }
}
