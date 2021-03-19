//
//  NavigationController.swift
//  SDNS Actions
//
//  Created by Corey Werner on 13/01/2021.
//

import UIKit

class NavigationController: UINavigationController {
    private lazy var settingsRouter: SettingsRouter = {
        let settingsRouter = SettingsRouter()
        settingsRouter.delegate = self
        return settingsRouter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [credentialsViewController]

        if Keychain.shared.email != nil && Keychain.shared.password != nil {
            settingsRouter.logIn()
            viewControllers.append(loginViewController)
        }
    }

    // MARK: Credentials

    private lazy var credentialsViewController: CredentialsViewController = {
        let viewController = CredentialsViewController(style: .insetGrouped)
        viewController.delegate = self
        viewController.title = "common.service".localized()
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(primaryAction: logInAction())
        return viewController
    }()

    private func logInAction() -> UIAction {
        return UIAction(title: "auth.log_in".localized()) { _ in
            self.logIn()
        }
    }

    private func logIn() {
        settingsRouter.logIn()
        pushViewController(loginViewController, animated: true)
    }

    // MARK: Loading

    private lazy var loadingViewController: ActivityIndicatorViewController = {
        let viewController = ActivityIndicatorViewController()
        viewController.navigationItem.hidesBackButton = true
        return viewController
    }()

    private var loginViewController: UIViewController {
        let viewController = loadingViewController
        viewController.title = "auth.log_in.active".localized()
        return viewController
    }

    private var logoutViewController: UIViewController {
        let viewController = loadingViewController
        viewController.title = "auth.log_out.active".localized()
        return viewController
    }

    // MARK: Settings

    private lazy var settingsViewController: SettingsViewController = {
        let viewController = SettingsViewController(style: .insetGrouped)
        viewController.delegate = self
        viewController.title = "common.service".localized()
        viewController.navigationItem.hidesBackButton = true
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(primaryAction: logOutAction())
        return viewController
    }()

    private func logOutAction() -> UIAction {
        return UIAction(title: "auth.log_out".localized()) { _ in
            self.settingsRouter.logOut()
            self.popToViewController(self.logoutViewController, animated: true)
        }
    }
}

extension NavigationController: CredentialsViewControllerDelegate {
    func credentialsViewControllerDidDismissKeyboard(_ viewController: CredentialsViewController) {
        logIn()
    }
}

extension NavigationController: SettingsRouterDelegate {
    func settingsRouterIsLoggedIn(_ settingsRouter: SettingsRouter) {
        pushViewController(settingsViewController, animated: true)
    }

    func settingsRouterIsLoggedOut(_ settingsRouter: SettingsRouter) {
        popToViewController(credentialsViewController, animated: true)
    }

    func settingsRouter(_ settingsRouter: SettingsRouter, actionDidFailWith error: Script.Error) {
        present(UIAlertController(error: error), animated: true)
    }
}

extension NavigationController: SettingsViewControllerDelegate {
    func settingsViewController(_ viewController: SettingsViewController, script: Script) {
        settingsRouter.evaluate(script: script)
    }
}
