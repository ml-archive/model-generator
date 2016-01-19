//
//  ModelParserTests.swift
//  model-generator-tests
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest

class ModelParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRegularExpressions() {
        XCTAssertNotNil(ModelParser.modelNameRegex, "Model name regex couldn't be created.")
        XCTAssertNotNil(ModelParser.structRegex, "Struct regex couldn't be created.")
        XCTAssertNotNil(ModelParser.finalClassRegex, "Final class regex couldn't be created.")
        XCTAssertNotNil(ModelParser.accessLevelRegex, "Access level regex couldn't be created.")
    }
    
    func testStructParsing() {
        let testSourceCode = "struct TestStruct : SomeOtherStruct {\nvar name: String?\nvar number: Int = 0\n}"

        do {
            let model = try ModelParser.modelFromSourceCode(testSourceCode)

            XCTAssertEqual(model.name, "TestStruct", "Struct name parsing failed.")
            XCTAssertEqual(model.type.rawValue, "struct", "Struct type parsing failed.")
            XCTAssertEqual(model.accessLevel.rawValue, "internal", "Struct access level parsing failed.")
        } catch {
            XCTAssert(false, "Model parsing failed: \(error).")
        }
    }

    func testClassParsing() {

    }

    func testAccessLevelParsing() {

    }
}
