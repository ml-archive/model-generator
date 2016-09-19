//
//  DecodableCodeGeneratorTests.swift
//  model-generator
//
//  Created by Dominik Hádl on 25/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest

class DecodableCodeGeneratorTests: XCTestCase {

    func testStructDecodableCode() {
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

        let code = DecodableCodeGenerator.decodableCode(withModel: model, useNativeDictionaries: false)

        XCTAssertEqual(code, "    init(dictionary: NSDictionary?) {\n        firstProperty  <== (self, dictionary, \"firstProperty\")\n        secondProperty <== (self, dictionary, \"this_isADifferentKey\")\n        thirdProperty  <== (self, dictionary, \"thirdProperty\")\n    }\n\n",
            "Decodable code generated for struct is not correct.")
    }

    func testClassDecodableCode() {
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

        let code = DecodableCodeGenerator.decodableCode(withModel: model, useNativeDictionaries: false)

        XCTAssertEqual(code, "    convenience init(dictionary: NSDictionary?) {\n        self.init()\n        a_property  <== (self, dictionary, \"a_property\")\n        fooProperty <== (self, dictionary, \"this_isADifferentKey\")\n        barProperty <== (self, dictionary, \"n\")\n    }\n\n",
            "Decodable code generated for class is not correct.")
    }

    func testDecodableStructCodeWithNativeDictionaries() {
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

        let code = DecodableCodeGenerator.decodableCode(withModel: model, useNativeDictionaries: true)

        XCTAssertEqual(code, "    init(dictionary: [String: AnyObject]?) {\n        firstProperty  = self.mapped(dictionary, key: \"firstProperty\") ?? firstProperty!\n        secondProperty = self.mapped(dictionary, key: \"this_isADifferentKey\")\n        thirdProperty  = self.mapped(dictionary, key: \"thirdProperty\")\n    }\n\n",
            "Decodable code generated for struct with native dictionaries is not correct.")
    }

    func testDecodableClassCodeWithNativeDictionaries() {
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

        let code = DecodableCodeGenerator.decodableCode(withModel: model, useNativeDictionaries: true)

        XCTAssertEqual(code, "    convenience init(dictionary: [String: AnyObject]?) {\n        self.init()\n        a_property  = self.mapped(dictionary, key: \"a_property\") ?? a_property!\n        fooProperty = self.mapped(dictionary, key: \"this_isADifferentKey\")\n        barProperty = self.mapped(dictionary, key: \"n\") ?? barProperty\n    }\n\n",
            "Decodable code generated for class with native dictionaries is not correct.")
    }
}
