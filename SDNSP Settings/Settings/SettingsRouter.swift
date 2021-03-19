//
//  SettingsRouter.swift
//  SDNS Actions
//
//  Created by Corey Werner on 05/02/2021.
//

import Foundation

protocol SettingsRouterDelegate: class {
    func settingsRouterIsLoggedIn(_ settingsRouter: SettingsRouter)
    func settingsRouterIsLoggedOut(_ settingsRouter: SettingsRouter)
    func settingsRouter(_ settingsRouter: SettingsRouter, actionDidFailWith error: Script.Error)
}

class SettingsRouter {
    weak var delegate: SettingsRouterDelegate?

    // MARK: Web

    private lazy var webController: WebController = {
        let webController = WebController()
        webController.delegate = self
        return webController
    }()

    func evaluate(script: Script) {
        webController.evaluate(script: script)
    }

    // MARK: Endpoint

    private var previousEndpoint: Endpoint?

    private var attemptEndpoint: Endpoint? {
        guard let path = webController.attemptPath else {
            return nil
        }

        return Endpoint(rawValue: path)
    }

    private func evaluate(success endpoint: Endpoint) {
        let previousEndpoint = self.previousEndpoint
        self.previousEndpoint = endpoint

        switch endpoint {
        case .login:
            if previousEndpoint == endpoint {
                settingsRouterIsLoggedOut()
            }
            else {
                logIn()
            }

        case .logout:
            settingsRouterIsLoggedOut()

        case .account:
            if previousEndpoint == .login {
                delegate?.settingsRouterIsLoggedIn(self)
            }

        case .region:
            break
        }
    }

    private func evaluate(failure endpoint: Endpoint) {
        switch endpoint {
        case .login, .logout:
            settingsRouterIsLoggedOut()

        case .account, .region:
            if attemptEndpoint == .logout {
                delegate?.settingsRouterIsLoggedIn(self)
            }
            else if attemptEndpoint == .login {
                settingsRouterIsLoggedOut()
            }
        }
    }

    private func settingsRouterIsLoggedOut() {
        previousEndpoint = nil
        delegate?.settingsRouterIsLoggedOut(self)
    }

    // MARK: Actions

    func logIn() {
        guard let email = Keychain.shared.email, let password = Keychain.shared.password else {
            settingsRouterIsLoggedOut()
            return
        }

        let script = Script(endpoint: .login, statement: SemicolonStatement([
            Statement().element(id: "txtEmail").setValue(email),
            Statement().element(id: "txtPassword").setValue(password),
            Statement().element(id: "btnSignIn").click()
        ]))
        script.delegate = self
        webController.evaluate(script: script)
    }

    func logOut() {
        let script = Script(endpoint: .logout)
        script.delegate = self
        webController.evaluate(script: script)
    }
}

extension SettingsRouter: WebControllerDelegate {
    func webController(_ webController: WebController, didNavigateToPath path: String) {
        guard let endpoint = Endpoint(rawValue: path) else {
            print("Unsupported path: \(path)")
            return
        }

        print("||| path success = \(endpoint)") // !!!: DEBUG

        evaluate(success: endpoint)
    }

    func webController(_ webController: WebController, didFailWith error: Error) {
        guard let path = webController.activePath else {
            settingsRouterIsLoggedOut()
            return
        }

        guard let endpoint = Endpoint(rawValue: path) else {
            print("Unsupported path: \(path)")
            return
        }

        print("||| path failure = \(endpoint)") // !!!: DEBUG

        evaluate(failure: endpoint)
    }
}

extension SettingsRouter: ScriptDelegate {
    func scriptDidEnd(_ script: Script, with error: Script.Error?) {
        if let error = error {
            delegate?.settingsRouter(self, actionDidFailWith: error)
        }
    }
}
