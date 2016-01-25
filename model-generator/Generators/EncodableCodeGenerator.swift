//
//  EncodableCodeGenerator.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

struct EncodableCodeGenerator {
    static func encodableCodeWithModel(model: Model, useNativeDictionaries: Bool) -> String {
        var indent = Indentation(level: 1)

        var code = indent.string() + (model.accessLevel == .Public ? "public " : "")
        code    += "func encodableRepresentation() -> NSCoding {\n"

        indent = indent.nextLevel()

        code += indent.string()
        code += (useNativeDictionaries ? "var dict = [String: AnyObject]()\n" : "let dict = NSMutableDictionary()\n")

        let maxPropertyLength = model.longestPropertyKeyLength()

        for property in model.properties {
            let keyCharactersCount = property.key?.characters.count ?? property.name.characters.count

            code += indent.string() + "dict[\"\(property.key ?? property.name)\"]"
            code += maxPropertyLength > keyCharactersCount ? String.repeated(" ", count: maxPropertyLength - keyCharactersCount) : ""
            code += " = \(property.name)"
            code += property.isPrimitiveType ? "" : "\(property.isOptional ? "?" : "").encodableRepresentation()"
            code += "\n"
        }

        code += indent.string() + "return dict\n"

        indent = indent.previousLevel()

        code += indent.string() + "}"

        return code
    }
}
