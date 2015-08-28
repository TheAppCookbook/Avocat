//
//  RedditComment.swift
//  Avocat
//
//  Created by PATRICK PERINI on 8/28/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import Foundation

struct Comment {
    // MARK: Properties
    let question: Question
    let attributedText: NSAttributedString
    let commentId: String
    let authorUsername: String
    
    var url: NSURL {
        return self.question.url.URLByAppendingPathComponent(self.commentId)
    }
}