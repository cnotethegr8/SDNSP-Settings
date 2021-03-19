//
//  GroupStatement.swift
//  SDNS Actions
//
//  Created by Corey Werner on 01/02/2021.
//

import Foundation

class GroupStatement: StatementProtocol {
    weak var delegate: StatementDelegate?

    var statements: [StatementProtocol]

    init(_ statements: [StatementProtocol]) {
        self.statements = statements
    }

    func javaScript() -> String {
        preconditionFailure(.override)
    }

    func set(output: Any) throws {
        preconditionFailure(.override)
    }
}
