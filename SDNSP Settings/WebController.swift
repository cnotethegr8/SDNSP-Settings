//
//  WebController.swift
//  SDNS Actions
//
//  Created by Corey Werner on 30/11/2020.
//

import WebKit

protocol WebControllerDelegate: class {
    func webController(_ webController: WebController, didNavigateToPath path: String)
    func webController(_ webController: WebController, didFailWith error: Error)
}

class WebController: NSObject {
    weak var delegate: WebControllerDelegate?

    // MARK: Web

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.isHidden = true
        UIApplication.shared.windows.first?.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        webView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return webView
    }()

    private var navigationCompletions: [(Script.Error?) -> Void] = []

    private func navigationDidComplete(error: Script.Error? = nil) {
        if navigationCompletions.isEmpty {
            return
        }

        let completions = navigationCompletions
        navigationCompletions.removeAll()
        completions.forEach({ $0(error) })
    }

    private func path(for url: URL) -> String? {
        var urlComponents = URLComponents(string: url.absoluteString)
        urlComponents?.scheme = nil
        urlComponents?.host = nil
        return urlComponents?.string
    }

    private(set) var attemptPath: String?

    var activePath: String? {
        guard let url = webView.url else {
            return nil
        }

        return path(for: url)
    }

    // MARK: Script

    private lazy var scriptsController: ScriptsController = {
        let controller = ScriptsController()
        controller.delegate = self
        return controller
    }()

    func evaluate(script: Script) {
        scriptsController.add(script)
    }

    private func evaluate(statement: StatementProtocol, completion: @escaping ((Script.Error?) -> Void)) {
        webView.evaluateJavaScript(statement.javaScript()) { value, error in
            if let error = error {
                completion(.failedRequest(error.localizedDescription))
                return
            }

            do {
                if let value = value {
                    try statement.set(output: value)
                }

                completion(nil)
            }
            catch let error as Script.Error {
                completion(error)
            }
            catch {
                completion(.unexpected(error.localizedDescription))
            }
        }
    }
}

extension WebController: ScriptsControllerDelegate {
    func scriptsController(_ scriptsController: ScriptsController, didSet url: URL, completion: @escaping (Script.Error?) -> Void) {
        if url == webView.url {
            completion(nil)
            return
        }

        attemptPath = path(for: url)
        webView.load(URLRequest(url: url))

        navigationCompletions.append(completion)
    }

    func scriptsController(_ scriptsController: ScriptsController, evaluate step: Script.Step, completion: @escaping (Script.Error?) -> Void) {
        switch step {
        case .statement(let statement):
            evaluate(statement: statement, completion: completion)

        case .reload:
            navigationCompletions.append(completion)
        }
    }
}

extension WebController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url else {
            print("Unable to get url")
            return
        }

        guard let path = path(for: url) else {
            print("Unable to get path for url: \(url.absoluteString)")
            return
        }

        delegate?.webController(self, didNavigateToPath: path)
        navigationDidComplete()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        delegate?.webController(self, didFailWith: error)
        navigationDidComplete(error: .failedRequest(error.localizedDescription))
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        delegate?.webController(self, didFailWith: error)
        navigationDidComplete(error: .failedRequest(error.localizedDescription))
    }
}
