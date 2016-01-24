//
//  Property.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

struct Property {
    static let primitiveTypes = [
        "Int", "Int8", "Int16", "Int32", "Int64",
        "UInt", "UInt8", "UInt16", "UInt32", "UInt64",
        "Bool", "Double", "Float", "String", "Char"
    ]

    let name: String
    let key: String?
    let isOptional: Bool
    let isPrimitiveType: Bool
    let hasDefaultValue: Bool
}