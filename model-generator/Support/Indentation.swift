//
//  Indentation.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

struct Indentation {
    static let defaultString = "    "

    let level: Int
    let customString: String?

    init(level: Int) {
        self.level = level
        self.customString = nil
    }

    init(level: Int, customString: String?) {
        self.level = level
        self.customString = customString
    }
}

extension Indentation {
    func string() -> String {
        var string = ""
        let indent = (customString ?? Indentation.defaultString)

        for _ in 0..<level {
            string += indent
        }

        return string
    }
}