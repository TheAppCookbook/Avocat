//
//  ViewController.swift
//  Avocat
//
//  Created by PATRICK PERINI on 8/28/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    @IBOutlet var commentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        RedditClient().questions { (qs: [Question]?) in
            RedditClient().comments(qs!.first!, completion: { (comments: (best: Comment, controversial: Comment)?) in
                self.commentLabel.attributedText = comments!.controversial.attributedText
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

