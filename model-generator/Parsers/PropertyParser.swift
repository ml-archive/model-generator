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
    case NoModelBodyDeclarationFound
    case MultipleModelBodyDeclarationsFound
    case NoTypeOrValueSpecified

    func description() -> String {
        switch self {
        case .GeneralError: return "General Error"
        case .NoModelBodyDeclarationFound: return "No Model Body Declaration Found"
        case .MultipleModelBodyDeclarationsFound: return "Multiple Model Body Declarations Found"
        case .NoTypeOrValueSpecified: return "A type or a default value has to be specified."
        }
    }
}

struct PropertyParser {
    static func propertiesFromSourceCode(sourceCode: String) throws -> [Property] {
        let modelBody = try PropertyParser.modelBodyFromSourceCode(sourceCode)
        let lines = modelBody.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())

        var properties: [Property] = []

        for line in lines {
            // Skip empty lines
            let trimmedLine = line.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if trimmedLine.characters.count == 0 { continue }

            // If line is commented out
            if trimmedLine.hasPrefix("//") { continue }

            // Check if line contains forbidden var types
            let invalidMatches = PropertyParser.invalidPropertyRegex?.numberOfMatchesInString(line)
            if let matches = invalidMatches where matches > 0 { continue }

            // Get property name
            guard let propertyNameMatch = PropertyParser.propertyNameRegex?.firstMatchInString(line) else { continue }
            let propertyName = line.substringWithRange(propertyNameMatch.range)

            let hasType: Bool
            let isOptional: Bool
            var isPrimitive = false

            // Figure out type of property
            let propertyTypeMatch = PropertyParser.propertyTypeRegex?.firstMatchInString(line)
            if let range = propertyTypeMatch?.range {
                hasType = true

                // Check if optional
                let type = line.substringWithRange(range)
                isOptional = type.containsString("?")

                // Check if primitive type
                let pureType = type.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "?!"))
                isPrimitive = Property.primitiveTypes.contains(pureType)
            } else {
                hasType = false
                isOptional = false
            }

            // Check if property has default value
            let hasValue = (PropertyParser.containsValueRegex?.firstMatchInString(line) != nil)
            if !hasType && !hasValue { throw PropertyParserError.NoTypeOrValueSpecified }

            // Check if value is primitive, if property doesn't have a type
            if !isPrimitive && !hasType {
                if let primitiveMatches = PropertyParser.primitiveValueRegex?.numberOfMatchesInString(line) where primitiveMatches > 0 {
                    isPrimitive = true
                } else {
                    isPrimitive = false
                }
            }

            // Find the override key if it exists
            let propertyKey: String?
            if let keyMatch = PropertyParser.keyOverrideRegex?.firstMatchInString(line) {
                propertyKey = line.substringWithRange(keyMatch.range)
            } else {
                propertyKey = nil
            }

            // Finally construct the property
            let property = Property(
                name: propertyName,
                key: propertyKey,
                isOptional:  isOptional,
                isPrimitiveType: isPrimitive,
                hasDefaultValue: hasValue)

            properties.append(property)
        }

        return properties
    }

    static func modelBodyFromSourceCode(sourceCode: String) throws -> String {
        let matches = PropertyParser.modelBodyRegex?.matchesInString(sourceCode, options: NSMatchingOptions(rawValue: 0), range: sourceCode.range)

        if let matches = matches, first = matches.first {
            if matches.count > 1 {
                throw PropertyParserError.MultipleModelBodyDeclarationsFound
            }

            return sourceCode.substringWithRange(first.range)
        }

        throw PropertyParserError.NoModelBodyDeclarationFound
    }
}

extension PropertyParser {
    static var modelBodyRegex: NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(
                pattern: "struct.*\\{(.*)\\}|class.*\\{(.*)\\}",
                options: [.DotMatchesLineSeparators])
            return regex
        } catch {
            print("Couldn't create model body regex.")
            return nil
        }
    }

    static var invalidPropertyRegex: NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(
                pattern: "(?:static|override|class)+[ ]+(?:public|internal|private)?[ ]+var",
                options: NSRegularExpressionOptions(rawValue: 0))
            return regex
        } catch {
            print("Couldn't create invalid property regex.")
            return nil
        }
    }

    static var propertyNameRegex: NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(
                pattern: "(?>[ ])(.*)(?=\\:)|(?>[ ]+)(.*)(?= \\=)",
                options: NSRegularExpressionOptions(rawValue: 0))
            return regex
        } catch {
            print("Couldn't create property name regex.")
            return nil
        }
    }

    static var propertyTypeRegex: NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(
                pattern: "(?>\\:[ ]*)(.*)(?= \\=)",
                options: NSRegularExpressionOptions(rawValue: 0))
            return regex
        } catch {
            print("Couldn't create property type regex.")
            return nil
        }
    }

    static var containsValueRegex: NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(
                pattern: "(?<!=\\/\\/)[ ]+(=)[ ]+",
                options: NSRegularExpressionOptions(rawValue: 0))
            return regex
        } catch {
            print("Couldn't create property contains value regex.")
            return nil
        }
    }

    static var primitiveValueRegex: NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(
                pattern: "(?>\\=[ ]*)(\".*\")|(?>\\=[ ]*)([0-9\\.\\-]+)|(?>\\=[ ]*)(true|false)",
                options: NSRegularExpressionOptions(rawValue: 0))
            return regex
        } catch {
            print("Couldn't create property primitive value regex.")
            return nil
        }
    }

    static var keyOverrideRegex: NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(
                pattern: "(?<=\\/\\/)[ ]+\\<\\-[ ]+([^\\s]+)[ ]*",
                options: NSRegularExpressionOptions(rawValue: 0))
            return regex
        } catch {
            print("Couldn't create property key override regex.")
            return nil
        }
    }
}