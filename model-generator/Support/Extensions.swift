//
//  Extensions.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

extension String {
    func substringWithRange(range: NSRange) -> String {
        return (self as NSString).substringWithRange(range)
    }

    var range: NSRange {
        get {
            return NSMakeRange(0, characters.count)
        }
    }
}

extension NSRegularExpression {
    public func numberOfMatchesInString(string: String) -> Int {
        return numberOfMatchesInString(string, options: NSMatchingOptions(rawValue: 0), range: string.range)
    }

    public func firstMatchInString(string: String) -> NSTextCheckingResult? {
        return firstMatchInString(string, options: NSMatchingOptions(rawValue: 0), range: string.range)
    }
}