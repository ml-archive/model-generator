//
//  main.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

let cli = CommandLine()

let sourceCode = StringOption(
    shortFlag: "s",
    longFlag: "sourceCode",
    required: true,
    helpMessage: "Source code for model generator to generate model boilerplate code.")


let moduleName = StringOption(
    shortFlag: "m",
    longFlag: "moduleName",
    required: false,
    helpMessage: "Optional module name to prepend to a struct/class name.")

cli.addOptions(sourceCode, moduleName)

do {
    try cli.parse()
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}

print(sourceCode.value)
print(moduleName.value)

private struct TestStruct {
    var name: String
}