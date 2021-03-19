//
//  SemicolonStatement.swift
//  SDNS Actions
//
//  Created by Corey Werner on 01/02/2021.
//

import Foundation

class SemicolonStatement: GroupStatement {
    override func javaScript() -> String {
        return statements.reduce("", { $0 + $1.javaScript() + ";" })
    }

    override func set(output: Any) throws {
        var statement = statements.last
        statement?.delegate = delegate
        try statement?.set(output: output)
    }
}
