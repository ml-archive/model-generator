//
//  EncodableCodeGeneratorTests.swift
//  model-generator
//
//  Created by Dominik Hádl on 25/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest

class EncodableCodeGeneratorTests: XCTestCase {

    func testStructEncodableCode() {
        var model = Model(name: "SomeModel", type: .Struct, accessLevel: .Private, properties: [])
        model.properties = [
            Property(
                name: "firstProperty",
                key: nil,
                isOptional:  true,
                isPrimitiveType: false,
                hasDefaultValue: true),
            Property(
                name: "secondProperty",
                key: "this_isADifferentKey",
                isOptional:  false,
                isPrimitiveType: true,
                hasDefaultValue: false),
            Property(
                name: "thirdProperty",
                key: nil,
                isOptional:  true,
                isPrimitiveType: true,
                hasDefaultValue: false)]

        let code = EncodableCodeGenerator.encodableCode(withModel: model, useNativeDictionaries: false)

        XCTAssertEqual(code, "    func encodableRepresentation() -> NSCoding {\n        let dict = NSMutableDictionary()\n        (dict, \"firstProperty\")        <== firstProperty\n        (dict, \"this_isADifferentKey\") <== secondProperty\n        (dict, \"thirdProperty\")        <== thirdProperty\n        return dict\n    }",
            "Encodable code generated for struct is not correct.")
    }

    func testClassEncodableCode() {
        var model = Model(name: "SomeModel", type: .Class, accessLevel: .Private, properties: [])
        model.properties = [
            Property(
                name: "a_property",
                key: nil,
                isOptional:  true,
                isPrimitiveType: false,
                hasDefaultValue: true),
            Property(
                name: "fooProperty",
                key: "this_isADifferentKey",
                isOptional:  true,
                isPrimitiveType: false,
                hasDefaultValue: false),
            Property(
                name: "barProperty",
                key: "n",
                isOptional:  false,
                isPrimitiveType: false,
                hasDefaultValue: true)]

        let code = EncodableCodeGenerator.encodableCode(withModel: model, useNativeDictionaries: false)

        XCTAssertEqual(code, "    func encodableRepresentation() -> NSCoding {\n        let dict = NSMutableDictionary()\n        (dict, \"a_property\")           <== a_property\n        (dict, \"this_isADifferentKey\") <== fooProperty\n        (dict, \"n\")                    <== barProperty\n        return dict\n    }",
            "Encodable code generated for class is not correct.")
    }

    func testEncodableStructCodeWithNativeDictionaries() {
        var model = Model(name: "SomeModel", type: .Struct, accessLevel: .Private, properties: [])
        model.properties = [
            Property(
                name: "firstProperty",
                key: nil,
                isOptional:  true,
                isPrimitiveType: false,
                hasDefaultValue: true),
            Property(
                name: "secondProperty",
                key: "this_isADifferentKey",
                isOptional:  false,
                isPrimitiveType: true,
                hasDefaultValue: false),
            Property(
                name: "thirdProperty",
                key: nil,
                isOptional:  true,
                isPrimitiveType: true,
                hasDefaultValue: false)]

        let code = EncodableCodeGenerator.encodableCode(withModel: model, useNativeDictionaries: true)

        XCTAssertEqual(code, "    func encodableRepresentation() -> NSCoding {\n        var dict = [String: AnyObject]()\n        dict[\"firstProperty\"]        = firstProperty?.encodableRepresentation()\n        dict[\"this_isADifferentKey\"] = secondProperty\n        dict[\"thirdProperty\"]        = thirdProperty\n        return dict\n    }",
            "Encodable code generated for struct with native dictionaries is not correct.")
    }

    func testEncodableClassCodeWithNativeDictionaries() {
        var model = Model(name: "SomeModel", type: .Class, accessLevel: .Private, properties: [])
        model.properties = [
            Property(
                name: "a_property",
                key: nil,
                isOptional:  true,
                isPrimitiveType: false,
                hasDefaultValue: true),
            Property(
                name: "fooProperty",
                key: "this_isADifferentKey",
                isOptional:  true,
                isPrimitiveType: false,
                hasDefaultValue: false),
            Property(
                name: "barProperty",
                key: "n",
                isOptional:  false,
                isPrimitiveType: false,
                hasDefaultValue: true)]

        let code = EncodableCodeGenerator.encodableCode(withModel: model, useNativeDictionaries: true)

        XCTAssertEqual(code, "    func encodableRepresentation() -> NSCoding {\n        var dict = [String: AnyObject]()\n        dict[\"a_property\"]           = a_property?.encodableRepresentation()\n        dict[\"this_isADifferentKey\"] = fooProperty?.encodableRepresentation()\n        dict[\"n\"]                    = barProperty.encodableRepresentation()\n        return dict\n    }",
            "Encodable code generated for class with native dictionaries is not correct.")
    }

}
