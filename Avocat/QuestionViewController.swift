//
//  QuestionViewController.swift
//  Avocat
//
//  Created by PATRICK PERINI on 8/28/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var questionView: UIView!
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var bestCommentLabel: UILabel!
    @IBOutlet var controversialCommentLabel: UILabel!
    
    @IBOutlet var questionViewTopConstraint: NSLayoutConstraint!
    var questionBackgroundColor: UIColor?
    
    var question: Question?
    var comments: (best: Comment, controversial: Comment)?
    private var redditClient: RedditClient = RedditClient()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.questionView.backgroundColor = self.questionBackgroundColor
        self.questionLabel.text = self.question?.titleText
        
        self.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: Data Handlers
    func reloadData() {
        self.redditClient.comments(self.question!) { (comments: (best: Comment, controversial: Comment)?) in
            self.comments = comments
            
            self.bestCommentLabel.attributedText = comments!.best.attributedText
            self.bestCommentLabel.alpha = 1.0
            
            self.controversialCommentLabel.attributedText = comments!.controversial.attributedText
            self.controversialCommentLabel.alpha = 1.0
        }
    }
    
    // MARK: Responders
    @IBAction func swipeGestureWasRecognized(sender: UISwipeGestureRecognizer!) {
        self.presentingViewController?.dismissViewControllerAnimated(true,
            completion: nil)
    }
}
