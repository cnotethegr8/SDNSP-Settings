//
//  CredentialsViewController.swift
//  SDNS Actions
//
//  Created by Corey Werner on 30/11/2020.
//

import UIKit

protocol CredentialsViewControllerDelegate: class {
    func credentialsViewControllerDidDismissKeyboard(_ viewController: CredentialsViewController)
}

class CredentialsViewController: UITableViewController {
    weak var delegate: CredentialsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        CredentialsDataSource.cells.forEach { tableView.register($0.self, forCellReuseIdentifier: $0.preferredReuseIdentifier) }

        tableView.keyboardDismissMode = .onDrag
    }

    private let sections = CredentialsDataSource.sections

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sections[indexPath.section].rows[indexPath.row].cell(in: tableView, for: indexPath)
        cell.textField.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension CredentialsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexPath = IndexPath(tag: textField.tag)

        sections[indexPath.section].rows[indexPath.row].update(text: textField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if let nextTextField = tableView.viewWithTag(textField.tag + 1) {
            nextTextField.becomeFirstResponder()
        }
        else {
            delegate?.credentialsViewControllerDidDismissKeyboard(self)
        }
        
        return true
    }
}
