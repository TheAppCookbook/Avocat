//
//  AppTests.swift
//  Avocat
//
//  Created by PATRICK PERINI on 9/11/15.
//  Copyright © 2015 AppCookbook. All rights reserved.
//

import XCTest

class AppTests: XCTestCase {
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
