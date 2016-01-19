//
//  Property.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

struct Property {
    let name: String
    let key: String
    let isOptional: Bool
    let isPrimitiveType: Bool
    let hasDefaultValue: Bool

    init(name: String, key: String?, isPrimitiveType: Bool, isOptional: Bool, hasDefaultValue: Bool) {
        self.name            = name
        self.key             = key ?? name
        self.isOptional      = isOptional
        self.isPrimitiveType = isPrimitiveType
        self.hasDefaultValue = hasDefaultValue
    }
}