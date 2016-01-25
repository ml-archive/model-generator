//
//  ModelGeneratorCLI.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

public final class ModelGeneratorCLI: CommandLine {

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

    let camelCaseConversion = BoolOption(
        shortFlag: "c",
        longFlag: "no-convert-camel-case",
        required: false,
        helpMessage: "Optionally don't convert property keys from camel case to underscores.")

    public init() {
        super.init()
        addOptions(sourceCode, moduleName, nativeDictionaries, camelCaseConversion)
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
            printUsage(error)
            exit(EX_USAGE)
        }
    }

    private func generateCode() {
        guard let code = sourceCode.value else {
            exit(EX_NOINPUT)
        }

        print("INPUT:\n", sourceCode.value, "\n\n")

        do {
            let modelCode = try ModelGenerator.modelCodeFromSourceCode(code)
            print("OUTPUT:\n\(modelCode)\n\n")
            exit(EX_OK)
        } catch {
            print("some error \(error)")
        }
    }
}
