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
        handSizeText.delegate = self
    }
    // MARK: Actions
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
    
    // UITextFieldDelegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handSizeText.resignFirstResponder()
        return true
    }
}
