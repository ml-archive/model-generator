//
//  ExtensionCodeGenerator.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

struct ExtensionCodeGenerator {
    static let protocolName = "Serializable"

    static func extensionCodeWithModel(model: Model, moduleName: String?, andContent content: String) -> String {
        var extensionString = "extension "

        // If applicable, adds module name and a dot
        // eg. "MyModule."
        if let moduleName = moduleName {
            extensionString += "\(moduleName)."
        }

        // Adds model name, protocol, bracket and a new line
        // eg. "MyModel: MyProtocol {\n"
        extensionString += "\(model.name): \(protocolName) {\n"

        // Add the content, new line and a closing bracket
        extensionString += "\(content)\n}"

        // Now return final extension string (example below has truncated content)
        // eg. "extension MyModule.MyModel: MyProtocol {\nCONTENT\n}"
        return extensionString
    }
}
