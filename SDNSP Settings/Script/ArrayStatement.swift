//
//  ArrayStatement.swift
//  SDNS Actions
//
//  Created by Corey Werner on 01/02/2021.
//

import Foundation

class ArrayStatement: GroupStatement {
    override func javaScript() -> String {
        var string = ""

        for (index, statement) in statements.enumerated() {
            string += statement.javaScript()

            if statements.count - 1 > index {
                string += ","
            }
        }

        return "[\(string)];"
    }

    override func set(output: Any) throws {
        guard let outputs = output as? [Any] else {
            throw Script.Error.invalidExpressionOutput
        }

        if outputs.count != statements.count {
            print("Unbalanced statements count: \(statements.count), outputs count: \(outputs.count)")
        }

        for (index, output) in outputs.enumerated() {
            var statement = statements[index]
            statement.delegate = delegate
            try statement.set(output: output)
        }
    }
}
