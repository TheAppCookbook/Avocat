//
//  RedditQuestion.swift
//  Avocat
//
//  Created by PATRICK PERINI on 8/28/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import Foundation

struct Question {
    // MARK: Properties
    let url: NSURL
    let pageTitle: String
    
    let titleText: String
    let questionId: String
    let explained: Bool
    let locked: Bool
    
    var urlPath: String {
        var components = self.url.pathComponents as [String]!
        components.removeAtIndex(0) // leading "/"
        return components.joinWithSeparator("/")
    }
    
    // MARK: Initializers
    init(url: NSURL, titleText: String, explained: Bool, locked: Bool) {
        // Assume:
        // "r/explainlikeimfive/comments/QUESTION_ID/QUESTION_TITLE/"
        
        var urlComponents = url.pathComponents!
        
        let title = urlComponents.removeLast() as String!
        let questionId = urlComponents.removeLast() as String!
        
        self.url = url
        self.pageTitle = title
        self.questionId = questionId
        
        self.explained = explained
        self.locked = locked
        
        var cleanedTitleText = titleText.stringByReplacingOccurrencesOfString("ELI5:",
            withString: "")
        cleanedTitleText = cleanedTitleText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        self.titleText = cleanedTitleText
    }
}