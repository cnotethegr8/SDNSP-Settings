//
//  ScriptError.swift
//  SDNS Actions
//
//  Created by Corey Werner on 10/03/2021.
//

import Foundation

extension Script {
    enum Error: Swift.Error {
        case conflictingURL
        case failedRequest(String)
        case invalidExpressionOutput
        case unexpected(String)
    }
}

extension Script.Error: CustomStringConvertible {
    var description: String {
        switch self {
        case .conflictingURL:
            return "script.error.conflicting_url".localized()

        case .failedRequest(let message):
            return message

        case .invalidExpressionOutput:
            return "script.error.invalid_expression_output".localized()

        case .unexpected(let message):
            return "script.error.unexpected".localized(withFormat: message)
        }
    }
}
