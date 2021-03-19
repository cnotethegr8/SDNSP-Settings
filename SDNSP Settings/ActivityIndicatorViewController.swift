//
//  ActivityIndicatorViewController.swift
//  SDNS Actions
//
//  Created by Corey Werner on 13/01/2021.
//

import UIKit

class ActivityIndicatorViewController: UIViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = activityIndicator
        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        activityIndicator.startAnimating()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        activityIndicator.stopAnimating()
    }
}
