//
//  QuestionListViewController.swift
//  Avocat
//
//  Created by PATRICK PERINI on 8/28/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import pop
import ACBInfoPanel

class QuestionListViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var filterControl: UISegmentedControl!
    @IBOutlet var searchBar: UITextField!

    @IBOutlet var filterHorizontalConstraint: NSLayoutConstraint!
    var searchBarIsShowing: Bool = false
    
    var redditClient: RedditClient = RedditClient()
    var questions: [Question] = []
    
    var colors: [UIColor] = [
        UIColor.redColor(),
        UIColor.greenColor()
    ]
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow() {
            self.tableView.deselectRowAtIndexPath(selectedIndexPath,
                animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case .Some("PushDetail"):
            let indexPath = sender as! NSIndexPath
            let question = self.questions[indexPath.row]
            
            let questionVC = segue.destinationViewController as! QuestionViewController
            questionVC.question = question
            questionVC.questionBackgroundColor = self.colors[indexPath.row % self.colors.count]
            
        default:
            break
        }
    }
    
    // MARK: Data Handlers
    func reloadData() {
        self.redditClient.questions { (questions: [Question]?) in
            if questions != nil {
                self.questions = questions!
            }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: Responders
    @IBAction func searchButtonWasPressed(sender: UIButton!) {
        if self.searchBarIsShowing {
            self.searchBarIsShowing = false
            
            let fadeAnim = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
            fadeAnim.toValue = 0.0
            self.searchBar.layer.pop_addAnimation(fadeAnim,
                forKey: "swap")
            
            let dragAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            dragAnim.toValue = 0.0
            self.filterHorizontalConstraint.pop_addAnimation(dragAnim,
                forKey: "swap")
            
            self.searchBar.resignFirstResponder()
            self.searchBar.text = nil
            sender.setImage(UIImage(named: "search")!,
                forState: .Normal)
        } else {
            self.searchBarIsShowing = true
            
            let dragAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            dragAnim.toValue = -self.view.frame.width
            self.filterHorizontalConstraint.pop_addAnimation(dragAnim,
                forKey: "swap")
            
            let fadeAnim = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
            fadeAnim.toValue = 1.0
            self.searchBar.layer.pop_addAnimation(fadeAnim,
                forKey: "swap")
            
            self.searchBar.becomeFirstResponder()
            sender.setImage(UIImage(named: "cancel")!,
                forState: .Normal)
        }
    }
    
    @IBAction func aboutButtonWasPressed(sender: UIButton!) {
        let infoPanel = ACBInfoPanelViewController()
        infoPanel.ingredient = "The Iran Nuclear Deal"
        
        self.presentViewController(infoPanel,
            animated: true,
            completion: nil)
    }
}

extension QuestionListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let question = self.questions[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("QuestionCell") as! UITableViewCell
        cell.backgroundColor = self.colors[indexPath.row % self.colors.count]
        
        let titleLabel = cell.viewWithTag(1) as! UILabel
        titleLabel.text = question.titleText
        
        return cell
    }
}

extension QuestionListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("PushDetail",
            sender: indexPath)
    }
}

