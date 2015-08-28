//
//  RedditClient.swift
//  Avocat
//
//  Created by PATRICK PERINI on 8/28/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import AFNetworking
import AFOnoResponseSerializer
import Ono

struct RedditClient {
    // MARK: Static Properities
    private static let baseURL: NSURL = NSURL(string: "https://www.reddit.com")!
    private enum paths: String {
        case questions = "r/explainlikeimfive/"
    }
    
    // MARK: Properties
    private let client: AFHTTPRequestOperationManager = {
        let client = AFHTTPRequestOperationManager(baseURL: RedditClient.baseURL)
        client.responseSerializer = AFOnoResponseSerializer.HTMLResponseSerializer()
        return client
    }()
    
    // MARK: Accessors
    func questions(lastQuestion: Question? = nil, completion: ([Question]?) -> Void) {
        var params: NSMutableDictionary = ["count": 25]
        if let lastQuestionId = lastQuestion?.questionId {
            params["after"] = lastQuestionId
        }
        
        self.client.GET(RedditClient.paths.questions.rawValue, parameters: params, success: { (op: AFHTTPRequestOperation, resp: AnyObject) in
            if let responseDoc = resp as? ONOXMLDocument {
                var questions: [Question] = []
                
                let elements: NSEnumerator = responseDoc.CSS("a.title") as! NSEnumerator
                for element in elements {
                    if let questionElement = element as? ONOXMLElement {
                        var explained: Bool = false
                        var locked: Bool = false
                        
                        if let flair = questionElement.previousSibling {
                            if (flair.attributes["class"] as! String).hasPrefix("linkflairlabel") {
                                locked = (flair.attributes["title"] as! String) == "Locked"
                                explained = (flair.attributes["title"] as! String) == "Explained"
                            }
                        }
                        
                        let url = RedditClient.baseURL.URLByAppendingPathComponent(questionElement.attributes["href"] as! String)
                        questions.append(Question(url: url,
                            explained: explained,
                            locked: locked))
                    }
                }
                
                completion(questions)
            } else {
                completion(nil)
            }
        }, failure: { (op: AFHTTPRequestOperation, err: NSError) in
            completion(nil)
        })
    }
    
    func comments(question: Question, completion: ((best: Comment, controversial: Comment)?) -> Void) {
        var bestComment: Comment?
        var controversialComment: Comment?
        
        let zipRequests: (Comment?, Comment?) -> Void = { (best: Comment?, controversial: Comment?) in
            if best != nil {
                bestComment = best
            }
            
            if controversial != nil {
                controversialComment = controversial
            }
            
            if bestComment != nil && controversialComment != nil {
                completion((best: bestComment!, controversial: controversialComment!))
            }
        }
        
        // BEST Request...
        let bestParams: NSMutableDictionary = ["sort": "best"]
        let bestHandler: (Comment) -> Void = { (comment: Comment) in
            zipRequests(comment, nil)
        }
        
        self.comment(question, params: bestParams, handler: bestHandler)
        
        // CONTROVERSIAL Request...
        let controversialParams: NSMutableDictionary = ["sort": "controversial"]
        let controversialHandler: (Comment) -> Void = { (comment: Comment) in
            zipRequests(nil, comment)
        }
        
        self.comment(question, params: controversialParams, handler: controversialHandler)
    }
    
    private func comment(question: Question, params: NSDictionary, handler: (Comment) -> Void) {
        self.client.GET(question.urlPath, parameters: params, success: { (op: AFHTTPRequestOperation, resp: AnyObject) in
            if let responseDoc = resp as? ONOXMLDocument {
                var commentText = NSMutableAttributedString()
                
                let commentArea = responseDoc.firstChildWithCSS("div.commentarea")
                let username = commentArea.firstChildWithCSS("a.author").stringValue()
                
                let userTextElement = commentArea.firstChildWithCSS("div.usertext-body")
                let commentId = userTextElement.previousSibling.attributes["value"] as! String
                
                let elements: NSEnumerator = userTextElement.CSS("p") as! NSEnumerator
                for element in elements {
                    if let paragraphElement = element as? ONOXMLElement {
                        let paragraphData = paragraphElement.description.dataUsingEncoding(NSUTF8StringEncoding,
                            allowLossyConversion: true)!
                        
                        let paragraphText = NSAttributedString(data: paragraphData,
                            options: [
                                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                            ], documentAttributes: nil, error: nil)!
                        
                        commentText.appendAttributedString(paragraphText)
                    }
                }
                
                let comment = Comment(
                    attributedText: commentText,
                    commentId: commentId,
                    authorUsername: username
                )
                
                handler(comment)
            }
        }, failure: nil)
    }
}
