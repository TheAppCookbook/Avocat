//
//  StringExtensions.swift
//  Avocat
//
//  Created by PATRICK PERINI on 8/28/15.
//  Copyright (c) 2015 AppCookbook. All rights reserved.
//

import Foundation

extension String {
    var isCapitalized: Bool {
        var range = "A"..."Z"
        return range.contains(String(self[self.startIndex]))
    }
}