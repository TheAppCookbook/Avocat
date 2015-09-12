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
import HMSegmentedControl
import UIScrollView_InfiniteScroll

class QuestionListViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var filterToggle: SegmentedControl!
    @IBOutlet var searchBar: UITextField!

    @IBOutlet var filterHorizontalConstraint: NSLayoutConstraint!
    var searchBarIsShowing: Bool = false {
        didSet {
            if self.searchBarIsShowing != oldValue && !self.searchBarIsShowing {
                self.reloadData()
            }
            
            self.tableView.removeInfiniteScroll()
            if !self.searchBarIsShowing {
                self.tableView.addInfiniteScrollWithHandler { (tableView: AnyObject!) in
                    self.appendNextPage()
                    self.tableView.finishInfiniteScroll()
                }
            }
        }
    }
    
    var redditClient: RedditClient = RedditClient()
    
    var questions: [Question] = []
    var answeredQuestions: [Question] {
        return self.questions.filter { $0.explained }
    }
    
    // Colors
    var backgroundColors: [UIColor] = [
        UIColor(hexString: "#E6F18D"),
        UIColor(hexString: "#72B37E"),
        UIColor(hexString: "#437975"),
        UIColor(hexString: "#555C78")
    ]
    
    var textColors: [UIColor: UIColor] = [
        UIColor(hexString: "#E6F18D"): UIColor(hexString: "#437975"),
        UIColor(hexString: "#72B37E"): UIColor.whiteColor(),
        UIColor(hexString: "#437975"): UIColor.whiteColor(),
        UIColor(hexString: "#555C78"): UIColor.whiteColor()
    ]
    
    var statusBarStyles: [UIColor: UIStatusBarStyle] = [
        UIColor(hexString: "#E6F18D"): .Default,
        UIColor(hexString: "#72B37E"): .LightContent,
        UIColor(hexString: "#437975"): .LightContent,
        UIColor(hexString: "#555C78"): .LightContent
    ]
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filterToggle.sectionTitles = ["All", "Explained"]
        
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
            action: "refreshControlDidTrigger:",
            forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.searchBarIsShowing = false
        self.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(selectedIndexPath,
                animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case .Some("PushDetail"):
            let indexPath = sender as! NSIndexPath
            let question = self.questionForIndexPath(indexPath)
            
            let questionVC = segue.destinationViewController as! QuestionViewController
            questionVC.question = question
            questionVC.questionBackgroundColor = self.backgroundColors[indexPath.row % self.backgroundColors.count]
            questionVC.questionTextColor = self.textColors[questionVC.questionBackgroundColor!]
            questionVC.statusBarStyle = self.statusBarStyles[questionVC.questionBackgroundColor!]!
            
        default:
            break
        }
    }
    
    // MARK: Data Handlers
    func reloadData(completion: (() -> Void) = {}) {
        self.redditClient.questions { (questions: [Question]?) in
            self.questions = questions ?? []
            self.tableView.reloadData()
            completion()
        }
    }
    
    func questionForIndexPath(indexPath: NSIndexPath) -> Question {
        switch self.filterToggle.selectedSegmentIndex {
        case 1:
            return self.answeredQuestions[indexPath.row]
            
        default:
            return self.questions[indexPath.row]
        }
    }
    
    func appendNextPage() {
        self.redditClient.questions(lastQuestion: self.questions.last!) { (questions: [Question]?) in
            self.questions.appendContentsOf(questions!)
            self.tableView.reloadData()
        }
    }
    
    func search(query: String, completion: (() -> Void) = {}) {
        self.redditClient.search(query) { (questions: [Question]?) in
            if questions != nil {
                self.questions = questions!
            }
            
            self.tableView.reloadData()
            completion()
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
    
    @IBAction func toggleValueDidChange(sender: SegmentedControl!) {
        self.tableView.reloadData()
    }
    
    func refreshControlDidTrigger(sender: UIRefreshControl!) {
        if self.searchBarIsShowing {
            self.search(self.searchBar.text!) {
                sender.endRefreshing()
            }
        } else {
            self.reloadData {
                sender.endRefreshing()
            }
        }
    }
    
    @IBAction func searchFieldDidExit(sender: UITextField!) {
        self.search(sender.text!)
    }
}

extension QuestionListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.filterToggle.selectedSegmentIndex {
        case 0:
            return self.questions.count
            
        case 1:
            return self.answeredQuestions.count
            
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let question = self.questionForIndexPath(indexPath)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("QuestionCell") as UITableViewCell!
        cell.backgroundColor = self.backgroundColors[indexPath.row % self.backgroundColors.count]
        
        let titleLabel = cell.viewWithTag(1) as! UILabel
        titleLabel.text = question.titleText
        titleLabel.textColor = self.textColors[cell.backgroundColor!]
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = cell.backgroundColor! - UIColor(hexString: "#333333")
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
}

extension QuestionListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("PushDetail",
            sender: indexPath)
    }
}

