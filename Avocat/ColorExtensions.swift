//
//  ColorExtensions.swift
//  Avocat
//
//  Created by PATRICK PERINI on 8/28/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        var rgbValue: UInt32 = 0
        
        let scanner = NSScanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        scanner.scanHexInt(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0xFF) / 255.0,
            alpha: 1.0)
    }
    
    private func combine(rhs: UIColor, op: (CGFloat, CGFloat) -> CGFloat) -> UIColor {
        var lhsRed: CGFloat = 0.0
        var lhsGreen: CGFloat = 0.0
        var lhsBlue: CGFloat = 0.0
        var lhsAlpha: CGFloat = 0.0
        
        self.getRed(&lhsRed,
            green: &lhsGreen,
            blue: &lhsBlue,
            alpha: &lhsAlpha)
        
        var rhsRed: CGFloat = 0.0
        var rhsGreen: CGFloat = 0.0
        var rhsBlue: CGFloat = 0.0
        
        rhs.getRed(&rhsRed,
            green: &rhsGreen,
            blue: &rhsBlue,
            alpha: nil)
        
        return UIColor(red: op(lhsRed, rhsRed),
            green: op(lhsGreen, rhsGreen),
            blue: op(lhsBlue, rhsBlue),
            alpha: lhsAlpha)
    }
}

func +(lhs: UIColor, rhs: UIColor) -> UIColor {
    return lhs.combine(rhs, op: +)
}

func -(lhs: UIColor, rhs: UIColor) -> UIColor {
    return lhs.combine(rhs, op: -)
}