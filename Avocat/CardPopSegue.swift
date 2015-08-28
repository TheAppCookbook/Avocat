//
//  CardPopSegue.swift
//  Avocat
//
//  Created by PATRICK PERINI on 8/28/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import pop

@objc(CardPopSegue) class CardPopSegue: UIStoryboardSegue {
    override func perform() {
        let sourceVC = self.sourceViewController as! UIViewController
        if let destinationVC = self.destinationViewController as? UIViewController {
            
            let destinationView = destinationVC.view
            let destinationBounds = destinationView.bounds
            
            let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            
            scaleAnim.fromValue = NSValue(CGPoint: CGPoint.zeroPoint)
            scaleAnim.toValue = NSValue(CGPoint: CGPoint(x: 1.0, y: 1.0))
            
            scaleAnim.completionBlock = { (_: POPAnimation!, _: Bool) in
                sourceVC.presentViewController(destinationVC,
                    animated: false,
                    completion: nil)
            }
            
            sourceVC.view.addSubview(destinationView)
            destinationView.layer.pop_addAnimation(scaleAnim,
                forKey: "popIn")
        }
    }
}

@objc(CardShrinkSegue) class CardShrinkSegue: UIStoryboardSegue {
    override func perform() {
        let sourceVC = self.sourceViewController as! UIViewController
        sourceVC.dismissViewControllerAnimated(true,
            completion: nil)
        
//        if let destinationVC = self.destinationViewController as? UIViewController {
//        
//            let destinationView = destinationVC.view
//            let destinationBounds = destinationView.bounds
//            
//            let scaleAnim = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
//            
//            scaleAnim.fromValue = NSValue(CGPoint: CGPoint.zeroPoint)
//            scaleAnim.toValue = NSValue(CGPoint: CGPoint(x: 1.0, y: 1.0))
//            
//            scaleAnim.completionBlock = { (_: POPAnimation!, _: Bool) in
//                sourceVC.presentViewController(destinationVC,
//                    animated: false,
//                    completion: nil)
//            }
//            
//            sourceVC.view.addSubview(destinationView)
//            destinationView.layer.pop_addAnimation(scaleAnim,
//                forKey: "popIn")
//        }
    }
}