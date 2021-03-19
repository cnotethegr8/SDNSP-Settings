//
//  Statement.swift
//  SDNS Actions
//
//  Created by Corey Werner on 01/02/2021.
//

import Foundation

protocol StatementDelegate: class {
    func statement(_ statement: StatementProtocol, didReceive outputToken: OutputToken)
}

protocol StatementProtocol {
    var delegate: StatementDelegate? { get set }

    func javaScript() -> String
    func set(output: Any) throws
}

typealias Statement = Expression<Never>

class Expression<Output>: StatementProtocol {
    weak var delegate: StatementDelegate?

    // MARK: Statement

    fileprivate private(set) var string = "document"

    func javaScript() -> String {
        return string
    }

    func element(id: String) -> Self {
        string += ".getElementById('\(id)')"
        return self
    }

    func elements(tag: String, index: Int = 0) -> Self {
        string += ".getElementsByTagName('\(tag)')[\(index)]"
        return self
    }

    func parent() -> Self {
        string += ".parentElement"
        return self
    }

    func query(_ query: String, index: Int = 0) -> Self {
        string += ".querySelectorAll('\(query)')[\(index)]"
        return self
    }

    func attribute(_ attribute: String) -> Self {
        string += ".getAttribute('\(attribute)')"
        return self
    }

    func contains(class: String) -> Self {
        string += ".classList.contains('\(`class`)')"
        return self
    }

    func contains(text: String) -> Self {
        string += ".indexOf('\(text)') > -1"
        return self
    }

    func excludes(text: String) -> Self {
        string += ".indexOf('\(text)') === -1"
        return self
    }

    func setValue(_ value: String) -> Self {
        string += ".value = '\(value)'"
        return self
    }

    func text() -> Self {
        string += ".innerText"
        return self
    }

    func click() -> Self {
        string += ".click()"
        return self
    }

    // MARK: Output

    private let outputToken = OutputToken()

    private(set) var output: Output?

    func output(for token: OutputToken) -> Output? {
        return token == outputToken ? output : nil
    }

    func set(output: Any) throws {
        guard let output = output as? Output else {
            throw Script.Error.invalidExpressionOutput
        }

        self.output = output

        delegate?.statement(self, didReceive: outputToken)
    }
}
