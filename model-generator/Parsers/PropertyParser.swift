//
//  PropertyParser.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

enum PropertyParserError: ModelGeneratorErrorType {
    case GeneralError

    func description() -> String {
        switch self {
        case .GeneralError: return "General Error"
        }
    }
}

struct PropertyParser {
    static func propertiesFromSourceCode(sourceCode: String) throws -> [Property] {

        return []
    }
}