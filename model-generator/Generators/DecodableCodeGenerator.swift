//
//  DecodableCodeGenerator.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

struct DecodableCodeGenerator {
    static func decodableCodeWithModel(model: Model) -> String {
        var indent = Indentation(level: 1)

        var code = indent.string() + (model.accessLevel == .Public ? "public " : " ")
        code    += (model.type == .Class ? "convenience " : "") + "init(dictionary: NSDictionary?) {\n"

        indent = indent.nextLevel()

        if model.type == .Class {
            code += indent.string() + "self.init()\n"
        }

        let maxPropertyLength = model.longestPropertyLength()

        for property in model.properties {
            code += indent.string() + property.name
            code += String(count:maxPropertyLength - property.name.characters.count, repeatedValue:" " as Character)
            code += " = self.mapped(dictionary, key: \"\(property.key ?? property.name)\")"
            code += property.hasDefaultValue ? (" ?? \(property.name)\(property.isOptional ? "!" : "")") : ""
            code += "\n"
        }

        indent = indent.previousLevel()

        code += indent.string() + "}"
        code += "\n\n"

        return code
    }
}