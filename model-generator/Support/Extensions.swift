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
}