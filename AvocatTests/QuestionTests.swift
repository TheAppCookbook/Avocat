//
//  AvocatTests.swift
//  AvocatTests
//
//  Created by PATRICK PERINI on 8/28/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import XCTest

class QuestionTests: XCTestCase {
    func testSuccess() {
        let questionURL = NSURL(string: "r/explainlikeimfive/comments/QUESTION_ID/QUESTION_TITLE/")!
        let question = Question(url: questionURL,
            titleText: "",
            explained: false,
            locked: false)
        XCTAssertNotNil(question)
    }
}
