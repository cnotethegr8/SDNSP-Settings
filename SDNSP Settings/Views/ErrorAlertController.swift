//
//  ErrorAlertController.swift
//  SDNS Actions
//
//  Created by Corey Werner on 15/03/2021.
//

import UIKit

extension UIAlertController {
    convenience init(error: Script.Error) {
        self.init(title: "error.title".localized(), message: error.description, preferredStyle: .alert)
        addAction(.init(title: "common.ok".localized(), style: .cancel))
    }
}
