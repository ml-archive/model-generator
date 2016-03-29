//
//  ModelGenerator.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

public struct ModelGeneratorSettings {
    public var moduleName: String?
    public var noConvertCamelCase: Bool = false
    public var useNativeDictionaries: Bool = false
    public var onlyCreateInitializer: Bool = false
    
    public init() {}
}

public protocol ModelGeneratorErrorType: ErrorType {
    func description() -> String
}

public struct ModelGenerator {
    public static func modelCodeFromSourceCode(sourceCode: String, withSettings settings: ModelGeneratorSettings) throws -> String {
        // Parse the model and its properties first
        var model        = try ModelParser.modelFromSourceCode(sourceCode)
        model.properties = try PropertyParser.propertiesFromSourceCode(sourceCode, noConvertCamelCaseKeys: settings.noConvertCamelCase)
        
        // Genereate decodable code block
        let decodableCode = DecodableCodeGenerator.decodableCodeWithModel(model, useNativeDictionaries: settings.useNativeDictionaries)
        
        if settings.onlyCreateInitializer {
            return decodableCode
        }
        
        // Genereate encodable code block
        let encodableCode = EncodableCodeGenerator.encodableCodeWithModel(model, useNativeDictionaries: settings.useNativeDictionaries)
        
        // Combine both blocks in an extension block and return it
        return ExtensionCodeGenerator.extensionCodeWithModel(model, moduleName: nil, andContent: decodableCode + encodableCode)
    }
}

