//
//  Model.swift
//  model-generator
//
//  Created by Dominik Hádl on 19/01/16.
//  Copyright © 2016 Nodes. All rights reserved.
//

import Foundation

enum AccessLevel: String {
    case Internal = "internal"
    case Private  = "private"
    case Public   = "public"
}

enum ModelType: String {
    case Class      = "class"
    case Struct     = "struct"
}

struct Model {
    let name: String
    let type: ModelType
    let accessLevel: AccessLevel
    var properties: [Property]
}