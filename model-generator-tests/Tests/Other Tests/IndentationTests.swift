//
//  IndentationTests.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
@testable import ModelGenerator

class IndentationTests: XCTestCase {

    func testZeroIndent() {
        let indent = Indentation(level: 0)
        let myString = "\(indent.string())test"

        XCTAssertEqual(myString.characters.count, 4, "Zero level indentation failed.")
    }

    func testNormalIndent() {
        let indent = Indentation(level: 3)
        let myString = "\(indent.string())test"

        let expected = (Indentation.defaultString.characters.count * 3) + 4

        XCTAssertEqual(myString.characters.count, expected, "Normal (level 3) indentation failed.")
    }

    func testHighIndent() {
        let level    = 3487
        let indent   = Indentation(level: 3487)
        let myString = "\(indent.string())test"

        let expected = (Indentation.defaultString.characters.count * level) + 4

        XCTAssertEqual(myString.characters.count, expected, "High level (\(level)) indentation failed.")
    }

    func testCustomIndent() {
        let indent   = Indentation(level: 3, customString: "       ")
        let myString = "\(indent.string())test"

        XCTAssertEqual(myString.characters.count, 25, "Indentation with custom string failed.")
    }
}
