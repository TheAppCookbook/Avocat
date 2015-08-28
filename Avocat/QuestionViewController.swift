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
    var questionTextColor: UIColor?
    var statusBarStyle: UIStatusBarStyle = .Default
    
    @IBOutlet var commentGestureRecognizers: [TapGestureRecognizer] = []
    private var commentCard: UIView?
    
    var question: Question?
    var comments: (best: Comment, controversial: Comment)?
    private var redditClient: RedditClient = RedditClient()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.statusBarStyle
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.questionView.backgroundColor = self.questionBackgroundColor
        
        self.questionLabel.text = self.question?.titleText
        self.questionLabel.textColor = self.questionTextColor
        
        self.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case .Some("PresentComment"):
            let destinationVC = segue.destinationViewController as! CommentsViewController
            destinationVC.comments = self.comments
            destinationVC.initialToggleIndex = sender as! Int
            
        default:
            break
        }
    }
    
    // MARK: Data Handlers
    func reloadData() {
        self.redditClient.comments(self.question!) { (comments: (best: Comment, controversial: Comment)?) in
            self.comments = comments
            for gestureRecognizer in self.commentGestureRecognizers {
                gestureRecognizer.enabled = true
            }
            
            self.bestCommentLabel.attributedText = comments!.best.attributedText
            self.bestCommentLabel.alpha = 1.0
            
            self.controversialCommentLabel.attributedText = comments!.controversial.attributedText
            self.controversialCommentLabel.alpha = 1.0
        }
    }
    
    // MARK: Responders
    @IBAction func dismissGestureWasRecognized(sender: UIGestureRecognizer!) {
        self.presentingViewController?.dismissViewControllerAnimated(true,
            completion: nil)
    }
    
    @IBAction func commentTapGestureWasRecognized(sender: TapGestureRecognizer!) {
        self.commentCard = sender.view!
        
        var toggleIndex = 0
        if sender.identifier == "Controversial" {
            toggleIndex = 1
        }
        
        self.performSegueWithIdentifier("PresentComment",
            sender: toggleIndex)
    }
}

extension QuestionViewController: CardExpansionSourceViewController {
    var expansionView: UIView { return self.commentCard! }
}
