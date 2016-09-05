//
//  PropertyParser.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

public enum PropertyParserError: ModelGeneratorErrorType {
    case GeneralError
    case NoModelBodyDeclarationFound
    case MultipleModelBodyDeclarationsFound
    case NoTypeOrValueSpecified

    public func description() -> String {
        switch self {
        case .GeneralError: return "General Error"
        case .NoModelBodyDeclarationFound: return "No Model Body Declaration Found"
        case .MultipleModelBodyDeclarationsFound: return "Multiple Model Body Declarations Found"
        case .NoTypeOrValueSpecified: return "A type or a default value has to be specified."
        }
    }
}

struct PropertyParser {
    static func propertiesFromSourceCode(sourceCode: String, noConvertCamelCaseKeys: Bool) throws -> [Property] {
        let modelBody = try PropertyParser.modelBodyFromSourceCode(sourceCode: sourceCode)
        let lines = modelBody.components(separatedBy: NSCharacterSet.newlines)

        var properties: [Property] = []

        for line in lines {
            // Skip empty lines
            let trimmedLine = line.trimWhitespace()
            if trimmedLine.characters.count == 0 { continue }

            // If line is commented out
            if trimmedLine.hasPrefix("//") { continue }

            // Check if line contains forbidden var types
            let invalidMatches = PropertyParser.invalidPropertyRegex?.numberOfMatchesInString(string: line)
            if let matches = invalidMatches , matches > 0 { continue }

            // Get property name
            guard let propertyNameMatch = PropertyParser.propertyNameRegex?.firstMatchInString(string: line) else { continue }
            let propertyName = line.substringWithRange(range: propertyNameMatch.range)

            let hasType: Bool
            let isOptional: Bool
            var isPrimitive = false

            // Figure out type of property
            let propertyTypeMatch = PropertyParser.propertyTypeRegex?.firstMatchInString(string: line)
            if let range = propertyTypeMatch?.range {
                hasType = true

                // Check if optional
                let type = line.substringWithRange(range: range)
                isOptional = type.contains("?")

                // Check if primitive type
                let pureType = type.trimmingCharacters(in: NSCharacterSet(charactersIn: "?! ") as CharacterSet)
                isPrimitive = Property.primitiveTypes.contains(pureType)
            } else {
                hasType = false
                isOptional = false
            }

            // Check if property has default value
            let hasValue = (PropertyParser.containsValueRegex?.firstMatchInString(string: line) != nil)
            if !hasType && !hasValue { throw PropertyParserError.NoTypeOrValueSpecified }

            // Check if value is primitive, if property doesn't have a type
            if !isPrimitive && !hasType {
                if let primitiveMatches = PropertyParser.primitiveValueRegex?.numberOfMatchesInString(string: line) , primitiveMatches > 0 {
                    isPrimitive = true
                } else {
                    isPrimitive = false
                }
            }

            // Find the override key if it exists
            let propertyKey: String?
            if let keyMatch = PropertyParser.keyOverrideRegex?.firstMatchInString(string: line) {
                propertyKey = line.substringWithRange(range: keyMatch.range).trimCharacters(inString: " <-")
            } else {
                propertyKey = noConvertCamelCaseKeys ? nil : propertyName.camelCaseToUnderscore()
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
        let matches = PropertyParser.modelBodyRegex?.matches(in: sourceCode, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: sourceCode.range)

        if let matches = matches, let first = matches.first {
            if matches.count > 1 {
                throw PropertyParserError.MultipleModelBodyDeclarationsFound
            }

            return sourceCode.substringWithRange(range: first.range)
        }

        throw PropertyParserError.NoModelBodyDeclarationFound
    }
}

extension PropertyParser {
    static var modelBodyRegex: NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(
                pattern: "struct.*\\{(.*)\\}|class.*\\{(.*)\\}",
                options: [.dotMatchesLineSeparators])
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
                options: NSRegularExpression.Options(rawValue: 0))
            return regex
        } catch {
            print("Couldn't create invalid property regex.")
            return nil
        }
    }

    static var propertyNameRegex: NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(
                pattern: "(?<=var )[ ]*([^\\s]*)(?=[ ]*\\:)|(?<=var )[ ]*([^\\s]*)(?=[ ]*\\=)",
                options: NSRegularExpression.Options(rawValue: 0))
            return regex
        } catch {
            print("Couldn't create property name regex.")
            return nil
        }
    }

    static var propertyTypeRegex: NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(
                pattern: "(?<=\\:)(?:[ ]*)([^\\s]*[?])|(?<=\\:)(?:[ ]*)([^\\s]*)(?=[ ]*\\=)",
                options: NSRegularExpression.Options(rawValue: 0))
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
                options: NSRegularExpression.Options(rawValue: 0))
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
                options: NSRegularExpression.Options(rawValue: 0))
            return regex
        } catch {
            print("Couldn't create property primitive value regex.")
            return nil
        }
    }

    static var keyOverrideRegex: NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(
                pattern: "(?<=\\/\\/)[ ]*\\<\\-[ ]*([^\\s]+)[ ]*",
                options: NSRegularExpression.Options(rawValue: 0))
            return regex
        } catch {
            print("Couldn't create property key override regex.")
            return nil
        }
    }
}
