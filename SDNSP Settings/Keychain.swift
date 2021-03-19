//
//  Keychain.swift
//  SDNS Actions
//
//  Created by Corey Werner on 02/01/2021.
//

import KeychainAccess

final class Keychain {
    static let shared = Keychain()

    private let keychain = KeychainAccess.Keychain(server: "https://smartdnsproxy.com", protocolType: .https)

    private init() {}

    var email: String? {
        get { keychain[Key.email.rawValue] }
        set { keychain[Key.email.rawValue] = newValue }
    }

    var password: String? {
        get { keychain[Key.password.rawValue] }
        set { keychain[Key.password.rawValue] = newValue }
    }
}

private extension Keychain {
    enum Key: String {
        case email
        case password
    }
}
