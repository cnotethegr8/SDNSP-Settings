//
//  ScriptsController.swift
//  SDNS Actions
//
//  Created by Corey Werner on 20/02/2021.
//

import Foundation

protocol ScriptsControllerDelegate: class {
    func scriptsController(_ scriptsController: ScriptsController, didSet url: URL, completion: @escaping (Script.Error?) -> Void)
    func scriptsController(_ scriptsController: ScriptsController, evaluate step: Script.Step, completion: @escaping (Script.Error?) -> Void)
}

class ScriptsController {
    weak var delegate: ScriptsControllerDelegate?

    private var executables: [Executable] = []

    private var url: URL? { executables.first?.script.url }

    func add(_ script: Script) {
        let isExecutablesEmpty = executables.isEmpty

        if isExecutablesEmpty || script.url == url {
            let executable = Executable(script: script)
            executables.append(executable)

            script.start()

            if isExecutablesEmpty {
                delegate?.scriptsController(self, didSet: script.url) { [weak self] error in
                    self?.delegateCompletion(error: error, executable: executable)
                }
            }
            else {
                evaluate(executable: executable)
            }
        }
        else {
            script.end(error: .conflictingURL)
        }
    }

    private func evaluate(executable: Executable) {
        guard let step = executable.nextStep() else {
            remove(executable: executable)
            executable.script.end()
            return
        }

        delegate?.scriptsController(self, evaluate: step, completion: { [weak self] error in
            self?.delegateCompletion(error: error, executable: executable)
        })
    }

    private func remove(executable: Executable) {
        guard let index = executables.firstIndex(where: { $0.script == executable.script }) else {
            print("Unable to remove executable")
            return
        }

        executables.remove(at: index)
    }

    private func delegateCompletion(error: Script.Error?, executable: Executable) {
        if let error = error {
            remove(executable: executable)
            executable.script.end(error: error)
        }
        else {
            evaluate(executable: executable)
        }
    }
}

private extension ScriptsController {
    class Executable {
        let script: Script
        private var stepsIterator: IndexingIterator<[Script.Step]>

        init(script: Script) {
            self.script = script
            self.stepsIterator = script.steps.makeIterator()
        }

        func nextStep() -> Script.Step? {
            return stepsIterator.next()
        }
    }
}

private extension Script {
    func start() {
        delegate?.scriptDidStart(self)
    }

    func end(error: Error? = nil) {
        delegate?.scriptDidEnd(self, with: error)
    }
}
