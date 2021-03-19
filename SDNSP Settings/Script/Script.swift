//
//  Script.swift
//  SDNS Actions
//
//  Created by Corey Werner on 30/11/2020.
//

import Foundation

protocol ScriptDelegate: class {
    func scriptDidStart(_ script: Script)
    func scriptDidEnd(_ script: Script, with error: Script.Error?)
    func script(_ script: Script, didReceive outputToken: OutputToken)
}

extension ScriptDelegate {
    func scriptDidStart(_ script: Script) {}
    func scriptDidEnd(_ script: Script, with error: Script.Error?) {}
    func script(_ script: Script, didReceive outputToken: OutputToken) {}
}

class Script: NSObject {
    weak var delegate: ScriptDelegate?

    let url: URL

    init(endpoint: Endpoint, statement: StatementProtocol? = nil) {
        url = endpoint.url

        super.init()

        if let statement = statement {
            addStatement(statement)
        }
    }

    private(set) var steps: [Step] = []

    func addStatement(_ statement: StatementProtocol) {
        var statement = statement
        statement.delegate = self

        steps.append(.statement(statement))
    }

    func addWaitForReload() {
        steps.append(.reload)
    }

    override var description: String {
        var string = super.description

        if let index = string.lastIndex(of: ">") {
            string.insert(contentsOf: "; url = \(url.absoluteString)", at: index)
        }

        return string
    }
}

extension Script: StatementDelegate {
    func statement(_ statement: StatementProtocol, didReceive outputToken: OutputToken) {
        delegate?.script(self, didReceive: outputToken)
    }
}

extension Script {
    enum Step {
        case statement(StatementProtocol)
        case reload
    }
}
