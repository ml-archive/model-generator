//
//  ModelGenerator.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

struct ModelGeneratorSettings {
    var moduleName: String?
    var noConvertCamelCase: Bool = false
    var useNativeDictionaries: Bool = false
}

protocol ModelGeneratorErrorType: ErrorType {
    func description() -> String
}

struct ModelGenerator {
    static func modelCodeFromSourceCode(sourceCode: String, withSettings settings: ModelGeneratorSettings) throws -> String {
        var model        = try ModelParser.modelFromSourceCode(sourceCode)
        model.properties = try PropertyParser.propertiesFromSourceCode(sourceCode, noConvertCamelCaseKeys: settings.noConvertCamelCase)

        let decodableCode = DecodableCodeGenerator.decodableCodeWithModel(model, useNativeDictionaries: settings.useNativeDictionaries)
        let encodableCode = EncodableCodeGenerator.encodableCodeWithModel(model, useNativeDictionaries: settings.useNativeDictionaries)

        return ExtensionCodeGenerator.extensionCodeWithModel(model, moduleName: nil, andContent: decodableCode + encodableCode)
    }
}
