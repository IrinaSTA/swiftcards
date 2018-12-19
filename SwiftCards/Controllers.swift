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
    static var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    static var home: HomePageViewController!
    static var joiner = storyBoard.instantiateViewController(withIdentifier: "JoinerViewController") as! JoinerViewController
    static var setup = storyBoard.instantiateViewController(withIdentifier: "SetupViewController") as! SetupViewController
    static var game = storyBoard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
}
