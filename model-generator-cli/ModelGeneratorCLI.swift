//
//  ModelGeneratorCLI.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

public final class ModelGeneratorCLI: CommandLineKit {

    let sourceCode = StringOption(
        shortFlag: "s",
        longFlag: "source-code",
        required: true,
        helpMessage: "Source code for model generator to generate model boilerplate code.")

    let moduleName = StringOption(
        shortFlag: "m",
        longFlag: "module-name",
        required: false,
        helpMessage: "Optional module name to prepend to a struct/class name.")

    let nativeDictionaries = BoolOption(
        shortFlag: "n",
        longFlag: "native-swift-dictionaries",
        required: false,
        helpMessage: "Optionally use native swift dictionaries instead of NSDictionary in generated model code.")

    let noCamelCaseConversion = BoolOption(
        shortFlag: "c",
        longFlag: "no-convert-camel-case",
        required: false,
        helpMessage: "Optionally don't convert property keys from camel case to underscores.")

    public init() {
        super.init()
        addOptions(sourceCode, moduleName, nativeDictionaries, noCamelCaseConversion)
    }

    public func run() {
        checkInput()
        generateCode()
    }

    // MARK: - Private -

    private func checkInput() {
        do {
            try parse()
        } catch {
            printUsage(error: error)
            exit(EX_USAGE)
        }
    }

    private func generateCode() {
        // If no source code provided, then exit
        guard let code = sourceCode.value else {
            exit(EX_NOINPUT)
        }

        // Create the generator settings
        var settings = ModelGeneratorSettings()
        settings.noConvertCamelCase    = noCamelCaseConversion.value
        settings.useNativeDictionaries = nativeDictionaries.value
        settings.moduleName            = moduleName.value

        // Try generating the model and print to stdout if success
        do {
            let modelCode = try ModelGenerator.modelCode(fromSourceCode: code, withSettings: settings)
            if let data = modelCode.data(using: String.Encoding.utf8) {
                FileHandle.standardOutput.write(data)
                exit(EX_OK)
            } else {
                exit(EXIT_FAILURE)
            }
        } catch {
            exit(EXIT_FAILURE)
        }
    }
}
