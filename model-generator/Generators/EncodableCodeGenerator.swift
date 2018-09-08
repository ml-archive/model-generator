//
//  EncodableCodeGenerator.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

struct EncodableCodeGenerator {
    static func encodableCode(withModel model: Model, useNativeDictionaries: Bool) -> String {
        var indent = Indentation(level: 1)

        // Create the function signature
        var code = indent.string() + (model.accessLevel == .Public ? "public " : "")
        code    += "func encodableRepresentation() -> NSCoding {\n"

        // Increase indent level
        indent = indent.nextLevel()

        // Create the dictionary
        code += indent.string()
        code += (useNativeDictionaries ? "var dict = [String: AnyObject]()\n" : "let dict = NSMutableDictionary()\n")

        // Get longest property key for alignment spaces
        let maxPropertyLength = model.longestPropertyKeyLength()

        // Generate encodable code for each property
        for property in model.properties {
            let keyCharactersCount = property.key?.count ?? property.name.unescaped.count
            code += indent.string()

            if useNativeDictionaries {
                code += "dict[\"\(property.key ?? property.name.unescaped)\"]"
                code += String.repeated(character: " ", count: maxPropertyLength - keyCharactersCount)
                code += " = \(property.name.escaped)"
                code += property.isPrimitiveType ? "" : "\(property.isOptional ? "?" : "").encodableRepresentation()"
            } else {
                code += "(dict, \"\(property.key ?? property.name.unescaped)\")"
                code += String.repeated(character: " ", count: maxPropertyLength - keyCharactersCount)
                code += " <== \(property.name.escaped)"
            }

            code += "\n"
        }

        // Return the dictionary
        code += indent.string() + "return dict\n"

        // Decrease the indent level
        indent = indent.previousLevel()

        // Close the function
        code += indent.string() + "}"

        return code
    }
}
