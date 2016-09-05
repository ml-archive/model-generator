//
//  Indentation.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

public struct Indentation {
    public static let defaultString = String(repeating: " ", count: 4)

    public let level: Int
    public let customString: String?

    public init(level: Int) {
        self.level = level
        self.customString = nil
    }

    public init(level: Int, customString: String?) {
        self.level = level
        self.customString = customString
    }
}

public extension Indentation {
    public func string() -> String {
        var string = ""
        let indent = (customString ?? Indentation.defaultString)

        for _ in 0..<level {
            string += indent
        }

        return string
    }
}

public extension Indentation {
    public func nextLevel() -> Indentation {
        return Indentation(level: level + 1, customString: customString)
    }

    public func previousLevel() -> Indentation {
        return Indentation(level: level > 0 ? level - 1 : 0, customString: customString)
    }
}
