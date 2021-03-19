//
//  String.swift
//  SDNS Actions
//
//  Created by Corey Werner on 09/01/2021.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }

    func localized(withFormat arguments: CVarArg...) -> String {
        return String(format: localized(), arguments: arguments)
    }
}

extension String {
    static let override = "Subclass needs to override."
}
