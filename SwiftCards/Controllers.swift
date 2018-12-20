//
//  Controllers.swift
//  SwiftCards
//
//  Created by Chris Cooksley on 19/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import Foundation
import UIKit

class Controllers {
    static let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    static var home: HomePageViewController!
    static var joiner = storyBoard.instantiateViewController(withIdentifier: "JoinerViewController") as! JoinerViewController
    static var setup = storyBoard.instantiateViewController(withIdentifier: "SetupViewController") as! SetupViewController
    static var game = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
    static func recreateViewControllers() {
        home = storyBoard.instantiateViewController(withIdentifier: "HomePageViewController") as? HomePageViewController
        joiner = storyBoard.instantiateViewController(withIdentifier: "JoinerViewController") as! JoinerViewController
        setup = storyBoard.instantiateViewController(withIdentifier: "SetupViewController") as! SetupViewController
        setup = storyBoard.instantiateViewController(withIdentifier: "SetupViewController") as! SetupViewController
        game = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
    }
}
