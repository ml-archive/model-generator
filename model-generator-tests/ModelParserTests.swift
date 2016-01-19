//
//  ModelParserTests.swift
//  model-generator-tests
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest

class ModelParserTests: XCTestCase {
    
    func testRegularExpressions() {
        XCTAssertNotNil(ModelParser.modelNameRegex, "Model name regex couldn't be created.")
        XCTAssertNotNil(ModelParser.structRegex, "Struct regex couldn't be created.")
        XCTAssertNotNil(ModelParser.finalClassRegex, "Final class regex couldn't be created.")
        XCTAssertNotNil(ModelParser.accessLevelRegex, "Access level regex couldn't be created.")
    }
    
    func testStructParsing() {
        let testSourceCode = "struct TestStruct: SomeOtherStruct {\nvar name: String?\nvar number: Int = 0\n}"

        do {
            let model = try ModelParser.modelFromSourceCode(testSourceCode)

            XCTAssertEqual(model.name, "TestStruct", "Struct name parsing failed.")
            XCTAssertEqual(model.type.rawValue, "struct", "Struct type parsing failed.")
            XCTAssertEqual(model.accessLevel.rawValue, "internal", "Struct access level parsing failed.")
        } catch {
            XCTAssert(false, "Struct parsing failed: \(error).")
        }
    }

    func testClassParsing() {
        let testSourceCode = "final private class TestClass: NSObject {\nvar name: String?\nvar number: Int = 0\n}"

        do {
            let model = try ModelParser.modelFromSourceCode(testSourceCode)

            XCTAssertEqual(model.name, "TestClass", "Class name parsing failed.")
            XCTAssertEqual(model.type.rawValue, "class", "Class type parsing failed.")
            XCTAssertEqual(model.accessLevel.rawValue, "private", "Class access level parsing failed.")
        } catch {
            XCTAssert(false, "Class parsing failed: \(error).")
        }
    }

    func testNonFinalClassParsing() {
        let testSourceCode = "public class TestClass: NSObject {\nfinal var name: String?\nvar number: Int = 0\n}"

        do {
            try ModelParser.modelFromSourceCode(testSourceCode)
            XCTAssert(false, "Non final class parsing should fail and instead parsed successfully.")
        } catch {
            XCTAssert(true)
        }
    }

    func testAccessLevelParsing() {
        let testOne = "final public class TestClass: NSObject {\nprivate var name: String?\npublic var number: Int = 0\n}"
        let testTwo = "internal final class TestClass: NSObject {\nprivate var name: String?\ninternal var number: Int = 0\n}"
        let testThree = "private struct TestClass: NSObject {\ninternal var name: String?\nprivate var number: Int = 0\n}"
        let testFour = "final class TestClass: NSObject {\nprivate var name: String?\nvar number: Int = 0\n}"

        do {
            let model = try ModelParser.modelFromSourceCode(testOne)
            XCTAssertEqual(model.accessLevel, AccessLevel.Public, "Public access level parsing failed.")
        } catch {
            XCTAssert(false, "Class parsing failed: \(error).")
        }

        do {
            let model = try ModelParser.modelFromSourceCode(testTwo)
            XCTAssertEqual(model.accessLevel, AccessLevel.Internal, "Internal access level parsing failed.")
        } catch {
            XCTAssert(false, "Class parsing failed: \(error).")
        }

        do {
            let model = try ModelParser.modelFromSourceCode(testThree)
            XCTAssertEqual(model.accessLevel, AccessLevel.Private, "Private access level parsing failed.")
        } catch {
            XCTAssert(false, "Struct parsing failed: \(error).")
        }

        do {
            let model = try ModelParser.modelFromSourceCode(testFour)
            XCTAssertEqual(model.accessLevel, AccessLevel.Internal, "Non-explicit internal access level parsing failed.")
        } catch {
            XCTAssert(false, "Class parsing failed: \(error).")
        }
    }

    func testStructParsingPerformance() {
        let testSourceCode = "final public class TestClass: NSObject {\nprivate var name: String?\npublic var number: Int = 0\n}"
        self.measureBlock { () -> Void in
            try! ModelParser.modelFromSourceCode(testSourceCode)
        }
    }

    func testClassParsingPerformance() {
        let testSourceCode = "private struct TestClass: NSObject {\ninternal var name: String?\nprivate var number: Int = 0\n}"
        self.measureBlock { () -> Void in
            try! ModelParser.modelFromSourceCode(testSourceCode)
        }
    }
}
