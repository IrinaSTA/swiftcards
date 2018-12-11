//
//  ViewController.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 10/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var handSizeText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    // MARK: Actions
    @IBAction func play(_ sender: UIButton) {
        convertStringToInteger()
    }
    @IBAction func returnKeyPressed(_ sender: Any) {
        convertStringToInteger()
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
