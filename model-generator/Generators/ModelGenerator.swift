//
//  ModelGenerator.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

protocol ModelGeneratorErrorType: ErrorType {
    func description() -> String
}

struct ModelGenerator {
    static func modelCodeFromSourceCode(sourceCode: String, withModuleName moduleName: String? = nil) throws -> String {
        var model        = try ModelParser.modelFromSourceCode(sourceCode)
        model.properties = try PropertyParser.propertiesFromSourceCode(sourceCode)

        let decodableCode = DecodableCodeGenerator.decodableCodeWithModel(model)
        let encodableCode = EncodableCodeGenerator.encodableCodeWithModel(model)

        return ExtensionCodeGenerator.extensionCodeWithModel(model, moduleName: nil, andContent: decodableCode + encodableCode)
    }
}
