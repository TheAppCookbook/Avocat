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
        return ("A"..."Z").contains(String(self[self.startIndex]))
    }
}