//
//  ModelParser.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

enum ModelParserError: ModelGeneratorErrorType {
    case ClassShouldBeDeclaredAsFinal

    case MultipleStructDeclarationsFound
    case MultipleClassDeclarationsFound
    case NoStructOrClassDeclarationFound

    case NoModelNameFound

    func description() -> String {
        switch self {
        case .ClassShouldBeDeclaredAsFinal:
            return "A class has to be defined as final."
        case .MultipleStructDeclarationsFound:
            return "Multiple `struct` declarations found in the source code."
        case .MultipleClassDeclarationsFound:
            return "Multiple `class` declarations found in the source code."
        case .NoStructOrClassDeclarationFound:
            return "No `class` or `struct` declaration found in the source code."
        case .NoModelNameFound:
            return "No struct or class name found in the source code."
        }
    }
}

struct ModelParser {
    static func modelFromSourceCode(sourceCode: String) throws -> Model {
        guard let modelType = try ModelParser.modelTypeForSourceCode(sourceCode) else {
            throw ModelParserError.NoStructOrClassDeclarationFound
        }

        let accessLevel = ModelParser.accessLevelForSourceCode(sourceCode)

        guard let name = ModelParser.modelNameForSourceCode(sourceCode) else {
            throw ModelParserError.NoModelNameFound
        }

        return Model(name: name, type: modelType, accessLevel: accessLevel, properties: [])
    }

    static func modelTypeForSourceCode(code: String) throws -> ModelType? {
        let range = NSMakeRange(0, code.characters.count)

        // Check if struct
        let structMatches = structRegex?.numberOfMatchesInString(code, options: NSMatchingOptions(rawValue: 0), range: range)
        if let matches = structMatches where matches == 1 {
            return .Struct
        } else if let matches = structMatches where matches > 1 {
            throw ModelParserError.MultipleStructDeclarationsFound
        }

        // Check if final class
        let finalClassMatches = finalClassRegex?.numberOfMatchesInString(code, options: NSMatchingOptions(rawValue: 0), range: range)
        if let matches = finalClassMatches where matches == 1 {
            return .Class
        } else if let matches = finalClassMatches where matches > 1 {
            throw ModelParserError.MultipleClassDeclarationsFound
        } else if code.containsString(ModelType.Class.rawValue) {
            throw ModelParserError.ClassShouldBeDeclaredAsFinal
        }

        // If no struct or class was found
        return nil
    }

    static func modelNameForSourceCode(code: String) -> String? {
        let range = NSMakeRange(0, code.characters.count)
        let match = modelNameRegex?.firstMatchInString(code, options: NSMatchingOptions(rawValue: 0), range: range)

        // If we found model name
        if let match = match {
            return code.substringWithRange(match.range)
        }

        return nil
    }

    static func accessLevelForSourceCode(code: String) -> AccessLevel {
        let range = NSMakeRange(0, code.characters.count)
        let match = accessLevelRegex?.firstMatchInString(code, options: NSMatchingOptions(rawValue: 0), range: range)

        if let match = match {
            return AccessLevel(rawValue: code.substringWithRange(match.range)) ?? .Internal
        }
        
        return .Internal
    }

}

// Regular expression used for parsing
extension ModelParser {
    static var finalClassRegex: NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(
                pattern: "final.*class(?=.*\\{)",
                options: NSRegularExpressionOptions(rawValue: 0))
            return regex
        } catch {
            print("Couldn't create final class regex.")
            return nil
        }
    }

    static var structRegex: NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(
                pattern: "struct(?=.*\\{)",
                options: NSRegularExpressionOptions(rawValue: 0))
            return regex
        } catch {
            print("Couldn't create struct regex.")
            return nil
        }
    }

    static var accessLevelRegex: NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(
                pattern: "private(?=.*class|.*struct)(?=.*\\{)|public(?=.*class|.*struct)(?=.*\\{)|internal(?=.*class|.*struct)(?=.*\\{)",
                options: NSRegularExpressionOptions(rawValue: 0))
            return regex
        } catch {
            print("Couldn't create access level regex.")
            return nil
        }
    }

    static var modelNameRegex: NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(
                pattern: "\\S+(?=\\s*\\:)|\\S+(?=\\s*\\{)",
                options: NSRegularExpressionOptions(rawValue: 0))
            return regex
        } catch {
            print("Couldn't create model name regex.")
            return nil
        }
    }
}
