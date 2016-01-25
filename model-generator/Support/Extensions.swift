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
        return String(count: count, repeatedValue: character)
    }

    func substringWithRange(range: NSRange) -> String {
        return (self as NSString).substringWithRange(range)
    }

    var range: NSRange {
        get {
            return NSMakeRange(0, characters.count)
        }
    }

    func trimWhitespace() -> String {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }

    func trimCharacters(inString: String) -> String {
        return stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: inString))
    }

    func camelCaseToUnderscore() -> String {
        var returnString = self

        let characterArray = Array(returnString.characters).map { (character) -> String in
            let inputCharacterString = String(character)
            let lowerCaseCharacterString = String(character).lowercaseString

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
        return numberOfMatchesInString(string, options: NSMatchingOptions(rawValue: 0), range: string.range)
    }

    public func firstMatchInString(string: String) -> NSTextCheckingResult? {
        return firstMatchInString(string, options: NSMatchingOptions(rawValue: 0), range: string.range)
    }
}