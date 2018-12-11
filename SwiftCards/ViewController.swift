//
//  ViewController.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 10/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var handSizeText: UITextField!
    // MARK: Actions
    @IBAction func play(_ sender: UIButton) {
    }
    @IBAction func ButtonPressed(_ sender: UIButton) {
        print(handSizeText.text)
    }
}
