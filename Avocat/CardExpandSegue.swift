//
//  CardExpandSegue.swift
//  Avocat
//
//  Created by PATRICK PERINI on 8/28/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit
import pop

protocol CardExpansionSourceViewController {
    var expansionView: UIView { get }
}

@objc(CardExpandSegue) class CardExpandSegue: UIStoryboardSegue {
    override func perform() {
        let sourceVC = self.sourceViewController as! UIViewController
        let destinationVC = self.destinationViewController as! UIViewController
        
        if let expansionView = (self.sourceViewController as? CardExpansionSourceViewController)?.expansionView {
            
            // Snapshot View
            let expansionSnapshotView = expansionView.snapshotViewAfterScreenUpdates(false)
            expansionSnapshotView.frame = expansionView.frame
            
            sourceVC.view.addSubview(expansionSnapshotView)
            
            let boundsAnim = POPSpringAnimation(propertyNamed: kPOPLayerBounds)
            boundsAnim.toValue = NSValue(CGRect: sourceVC.view.frame)
            
            let positionAnim = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
            positionAnim.toValue = NSValue(CGPoint: sourceVC.view.center)
            
            let fadeOutAnim = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
            fadeOutAnim.toValue = 0.0
            
            // Destination View
            let destinationView = destinationVC.view
            destinationView.layer.opacity = 0.0
            sourceVC.view.insertSubview(destinationView,
                belowSubview: expansionSnapshotView)
            
            let fadeInAnim = POPBasicAnimation(propertyNamed: kPOPLayerOpacity)
            fadeInAnim.toValue = 1.0
            
            fadeInAnim.completionBlock = { (_: POPAnimation!, _: Bool) in
                destinationView.removeFromSuperview()
                sourceVC.presentViewController(destinationVC,
                    animated: false,
                    completion: nil)
            }
            
            // Add animations
            expansionSnapshotView.layer.pop_addAnimation(boundsAnim,
                forKey: "expand")
            expansionSnapshotView.layer.pop_addAnimation(positionAnim,
                forKey: "position")
            expansionSnapshotView.layer.pop_addAnimation(fadeOutAnim,
                forKey: "fade")
            
            destinationView.layer.pop_addAnimation(fadeInAnim,
                forKey: "fade")
        }
    }
}
