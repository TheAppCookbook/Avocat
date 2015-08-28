//
//  EnumerationExtensions.swift
//  Avocat
//
//  Created by PATRICK PERINI on 8/28/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import UIKit

extension NSEnumerator : SequenceType {
    public func generate() -> NSFastGenerator {
        return NSFastGenerator(self)
    }
}
