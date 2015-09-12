//
//  CommentsViewController.swift
//  Avocat
//
//  Created by PATRICK PERINI on 8/28/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import HMSegmentedControl
import SafariServices

class CommentsViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var textView: UITextView!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var commentToggle: SegmentedControl!
    @IBOutlet var textScrollView: UIScrollView!
    
    var comments: (best: Comment, controversial: Comment)?
    var initialToggleIndex: Int = 0
    private var activeComment: Comment? {
        didSet {
            // Update appearance
            let attributedText = self.activeComment!.attributedText.mutableCopy() as! NSMutableAttributedString
            
            attributedText.addAttribute(NSFontAttributeName,
                value: self.textView.font!,
                range: NSMakeRange(0, attributedText.length))
            
            attributedText.addAttribute(NSForegroundColorAttributeName,
                value: self.textView.textColor!,
                range: NSMakeRange(0, attributedText.length))
            
            self.textView.attributedText = attributedText
            self.authorNameLabel.text = "- \(self.activeComment!.authorUsername)"
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commentToggle.type = HMSegmentedControlTypeImages
        self.commentToggle.templateImages = [
            UIImage(named: "best")!,
            UIImage(named: "controversial")!,
        ]
        
        self.commentToggle.selectedSegmentIndex = self.initialToggleIndex
        self.toggleValueDidChange(self.commentToggle)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: Responders
    @IBAction func toggleValueDidChange(sender: SegmentedControl!) {
        self.textScrollView.setContentOffset(CGPoint.zero,
            animated: false)
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.activeComment = self.comments!.best
            
        case 1:
            self.activeComment = self.comments!.controversial
            
        default:
            break
        }
    }
    
    @IBAction func dismissGestureWasRecognized(sender: UIGestureRecognizer!) {
        self.presentingViewController?.dismissViewControllerAnimated(true,
            completion: nil)
    }
    
    @IBAction func seeMoreButtonWasPressed(sender: UIButton!) {
        let safariVC = SFSafariViewController(URL: self.activeComment!.url)
        safariVC.view.tintColor = self.view.tintColor
        
        self.presentViewController(safariVC,
            animated: true,
            completion: nil)
    }
}
