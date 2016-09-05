//
//  Extensions.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

extension String {
    static func repeated(character: Character, count: Int) -> String {
        return String(repeating: "\(character)", count: count)
    }

    func substringWithRange(range: NSRange) -> String {
        return (self as NSString).substring(with: range)
    }

    var range: NSRange {
        get {
            return NSMakeRange(0, characters.count)
        }
    }

    func trimWhitespace() -> String {
        return trimmingCharacters(in: NSCharacterSet.whitespaces as CharacterSet)
    }

    func trimCharacters(inString: String) -> String {
        return trimmingCharacters(in: NSCharacterSet(charactersIn: inString) as CharacterSet)
    }

    func camelCaseToUnderscore() -> String {
        var returnString = self

        let characterArray = Array(returnString.characters).map { (character) -> String in
            let inputCharacterString = String(character)
            let lowerCaseCharacterString = String(character).lowercased()

            if inputCharacterString != lowerCaseCharacterString {
                return "_" + lowerCaseCharacterString
            }

            return inputCharacterString
        }

        returnString = characterArray.reduce("") {
            return $0 + $1
        }

        return returnString;
    }
}

extension NSRegularExpression {
    public func numberOfMatchesInString(string: String) -> Int {
        return numberOfMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: string.range)
    }

    public func firstMatchInString(string: String) -> NSTextCheckingResult? {
        return firstMatch(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: string.range)
    }
}
