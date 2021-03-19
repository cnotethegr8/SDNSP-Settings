//
//  SettingsViewController.swift
//  SDNS Actions
//
//  Created by Corey Werner on 12/01/2021.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func settingsViewController(_ viewController: SettingsViewController, script: Script)
}

class SettingsViewController: UITableViewController {
    weak var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SettingsDataSource.cells.forEach { tableView.register($0.self, forCellReuseIdentifier: $0.preferredReuseIdentifier) }
    }

    // MARK: Data Source

    private let sections = SettingsDataSource.sections

    private func row(for indexPath: IndexPath) -> SettingsRowData {
        return sections[indexPath.section].rows[indexPath.row]
    }

    private var scriptsToRowDetails: [Script: (UITableViewCell, IndexPath)] = [:]

    // MARK: Table View

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
        let cell = row(for: indexPath).cell(in: tableView, for: indexPath)

        if let cell = cell as? ToggleTableViewCell {
            cell.toggle.addTarget(self, action: #selector(valueDidChange(for:)), for: .valueChanged)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = self.row(for: indexPath)
        row.displayScript.delegate = self
        row.actionScript?.delegate = self

        scriptsToRowDetails[row.displayScript] = (cell, indexPath)

        if let actionScript = row.actionScript {
            scriptsToRowDetails[actionScript] = (cell, indexPath)
        }

        delegate?.settingsViewController(self, script: row.displayScript)
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = self.row(for: indexPath)
        row.displayScript.delegate = nil
        row.actionScript?.delegate = nil

        scriptsToRowDetails.removeValue(forKey: row.displayScript)

        if let actionScript = row.actionScript {
            scriptsToRowDetails.removeValue(forKey: actionScript)
        }
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    // MARK: Control

    @objc private func valueDidChange(for toggle: UISwitch) {
        guard let cell = toggle.superview as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            print("Can not find index path from toggle")
            revertChange(for: toggle)
            return
        }

        guard let actionScript = row(for: indexPath).actionScript else {
            print("Toggle changed without an action")
            revertChange(for: toggle)
            return
        }

        delegate?.settingsViewController(self, script: actionScript)
    }

    private func revertChange(for toggle: UISwitch) {
        toggle.setOn(!toggle.isOn, animated: true)
    }
}

extension SettingsViewController: ScriptDelegate {
    func scriptDidStart(_ script: Script) {
        guard let (cell, indexPath) = scriptsToRowDetails[script] else {
            return
        }

        row(for: indexPath).script(didStart: script, for: cell)
    }

    func scriptDidEnd(_ script: Script, with error: Script.Error?) {
        if let error = error {
            print("Script failed: \(script); Error: \(error.localizedDescription)")
            present(UIAlertController(error: error), animated: true)
        }

        guard let (cell, indexPath) = scriptsToRowDetails[script] else {
            return
        }

        row(for: indexPath).script(didEnd: script, for: cell, successfully: error == nil)
    }

    func script(_ script: Script, didReceive outputToken: OutputToken) {
        guard let (cell, indexPath) = scriptsToRowDetails[script] else {
            return
        }

        row(for: indexPath).statement(didReceive: outputToken, for: cell)
    }
}
