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
    static func modelCodeFromSourceCode(sourceCode: String) throws -> String {
        var model = try ModelParser.modelFromSourceCode(sourceCode)
        let properties = try PropertyParser.propertiesFromSourceCode(sourceCode)

        model.properties = properties



        return ""
    }
}
