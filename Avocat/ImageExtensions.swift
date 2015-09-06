//
//  ImageExtensions.swift
//  Avocat
//
//  Created by PATRICK PERINI on 8/28/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit

extension UIImage {
    func imageWithSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        self.drawInRect(CGRect(origin: CGPoint.zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func imageScaledToHeight(height: CGFloat) -> UIImage {
        let scaleFactor = height / self.size.height
        let newSize = CGSize(width: self.size.width * scaleFactor, height: self.size.height * scaleFactor)
        
        return self.imageWithSize(newSize)
    }
    
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        color.setFill()
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(),
            0, self.size.height)
        CGContextScaleCTM(UIGraphicsGetCurrentContext(),
            1.0, -1.0)
        
        let frame = CGRect(origin: CGPoint.zero, size: self.size)
        CGContextClipToMask(UIGraphicsGetCurrentContext(),
            frame, self.CGImage)
        CGContextFillRect(UIGraphicsGetCurrentContext(), frame)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage
    }
}
