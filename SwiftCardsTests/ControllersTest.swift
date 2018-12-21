//
//  ControllersTest.swift
//  SwiftCardsTests
//
//  Created by Irina Baldwin on 20/12/2018.
//  Copyright © 2018 Player$. All rights reserved.
//

import XCTest
@testable import SwiftCards

class ControllersTests: XCTestCase {
    func testRecreateViewControllers() {
        Controllers.recreateViewControllers()
        XCTAssert((Controllers.home as Any) is UIViewController)
        XCTAssert((Controllers.joiner as Any) is UIViewController)
        XCTAssert((Controllers.setup as Any) is UIViewController)
        XCTAssert((Controllers.game as Any) is UIViewController)
    }
    func testReturnsStoryBoard() {
        XCTAssert((Controllers.storyBoard as Any) is UIStoryboard)
    }
    func testReturnsHomeVC() {
        XCTAssert((Controllers.home as Any) is UIViewController)
    }
    func testReturnsJoinerVC() {
        XCTAssert((Controllers.joiner as Any) is UIViewController)
    }
    func testReturnsSetupVC() {
        XCTAssert((Controllers.setup as Any) is UIViewController)
    }
    func testReturnsGameVC() {
        XCTAssert((Controllers.game as Any) is UIViewController)
    }
}
