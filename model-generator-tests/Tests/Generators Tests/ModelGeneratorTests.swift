//
//  ModelGeneratorTests.swift
//  model-generator
//
//  Created by Dominik Hádl on 25/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import XCTest

class ModelGeneratorTests: XCTestCase {

    func testExtensionCode() {
        let model = Model(name: "SomeModel", type: .Struct, accessLevel: .Private, properties: [])
        let code = ExtensionCodeGenerator.extensionCodeWithModel(model, moduleName: nil, andContent: "    var myVar: String?\n    let myConst = 0\n\n    init() {\n        super.init()\n}")

        XCTAssertEqual(code, "extension SomeModel: Serializable {\n    var myVar: String?\n    let myConst = 0\n\n    init() {\n        super.init()\n}\n}",
            "Extension code generated with custom module name is not correct.")
    }

    func testNoContentExtensionCode() {
        let model = Model(name: "MyModel", type: .Class, accessLevel: .Public, properties: [])
        let code = ExtensionCodeGenerator.extensionCodeWithModel(model, moduleName: nil, andContent: "")

        XCTAssertEqual(code, "extension MyModel: Serializable {\n\n}",
            "Extension code generated with empty content is not correct.")
    }

    func testCustomModuleNameExtensionCode() {
        let model = Model(name: "YourModel", type: .Struct, accessLevel: .Private, properties: [])
        let code = ExtensionCodeGenerator.extensionCodeWithModel(model, moduleName: "SomeModule", andContent: "some content\nseparated by new lines\n\n")

        XCTAssertEqual(code, "extension SomeModule.YourModel: Serializable {\nsome content\nseparated by new lines\n\n\n}",
            "Extension code generated with custom module name is not correct.")
    }
}