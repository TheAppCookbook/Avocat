//
//  SegmentedControl.swift
//  Avocat
//
//  Created by PATRICK PERINI on 8/28/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import HMSegmentedControl

@IBDesignable class SegmentedControl: HMSegmentedControl {
    // MARK: Overrides
    @IBInspectable var rawSelectionStyle: Int = 0
    @IBInspectable var rawSelectionIndicatorLocation: Int = 0
    @IBInspectable var rawSelectionIndicatorColor: UIColor?
    @IBInspectable var rawSelectionIndicatorHeight: CGFloat = 5.0
    
    // MARK: Properties
    @IBInspectable var fontSize: CGFloat = 15.0
    @IBInspectable var fontFamily: String = ""
    
    var templateImages: [UIImage]? {
        willSet {
            self.sectionImages = newValue!.map {
                $0.imageScaledToHeight(self.frame.height * 0.66).imageWithColor(self.tintColor)
            }
            
            self.sectionSelectedImages = newValue!.map {
                $0.imageScaledToHeight(self.frame.height * 0.66).imageWithColor(self.selectionIndicatorColor)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = HMSegmentedControlSelectionStyle(UInt32(self.rawSelectionStyle))
        self.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation(UInt32(self.rawSelectionIndicatorLocation))
        
        let font = UIFont(name: self.fontFamily, size: self.fontSize) ?? UIFont.systemFontOfSize(self.fontSize)
        self.titleTextAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: self.tintColor
        ]
        
        self.selectionIndicatorColor = self.rawSelectionIndicatorColor
        self.selectedTitleTextAttributes = [
            NSForegroundColorAttributeName: self.selectionIndicatorColor
        ]

        self.selectionIndicatorHeight = self.rawSelectionIndicatorHeight
    }
}
