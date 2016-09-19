//
//  PropertyParserTests.swift
//  model-generator
//
//  Created by Dominik Hádl on 24/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest
import Foundation

class PropertyParserTests: XCTestCase {

    func testRegularExpressions() {
        XCTAssertNotNil(PropertyParser.modelBodyRegex, "Model body regex couldn't be created.")
        XCTAssertNotNil(PropertyParser.invalidPropertyRegex, "Invalid property couldn't be created.")
        XCTAssertNotNil(PropertyParser.propertyNameRegex, "Property name regex couldn't be created.")
        XCTAssertNotNil(PropertyParser.propertyTypeRegex, "Property type regex couldn't be created.")
        XCTAssertNotNil(PropertyParser.containsValueRegex, "Contains value regex couldn't be created.")
        XCTAssertNotNil(PropertyParser.primitiveValueRegex, "Primitive value regex couldn't be created.")
        XCTAssertNotNil(PropertyParser.keyOverrideRegex, "Key override regex couldn't be created.")
    }

    func testOptionalPropertyWithDefaultValue() {
        let testString = try! String(contentsOfFile: Bundle(for: type(of: self)).path(forResource: "PropertyParserTest1", ofType: "")!)
        let properties = try! PropertyParser.properties(fromSourceCode: testString, noConvertCamelCaseKeys: true)

        XCTAssertEqual(properties.count, 2, "Wrong number of properties parsed.")

        XCTAssertEqual(properties[0].name, "name", "Property name parsing failed.")
        XCTAssertEqual(properties[0].key, "keyName", "Property key override parsing failed.")
        XCTAssertTrue(properties[0].isPrimitiveType, "Wrong checking for primitive type.")
        XCTAssertFalse(properties[0].isOptional, "Optional parsed incorrectly.")
        XCTAssertTrue(properties[0].hasDefaultValue, "Default value check failed.")

        XCTAssertEqual(properties[1].name, "optionalNumber", "Property name parsing failed.")
        XCTAssertNil(properties[1].key, "Property key override parsing failed.")
        XCTAssertTrue(properties[1].isPrimitiveType, "Wrong checking for primitive type.")
        XCTAssertTrue(properties[1].isOptional, "Optional parsed incorrectly.")
        XCTAssertTrue(properties[1].hasDefaultValue, "Default value check failed.")
    }
}
