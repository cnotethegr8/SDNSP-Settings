//
//  SettingsRowData.swift
//  SDNS Actions
//
//  Created by Corey Werner on 17/02/2021.
//

import UIKit

class SettingsRowData: RowData {
    var displayScript: Script { preconditionFailure(.override) }
    var actionScript: Script? { nil }

    func cell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        preconditionFailure(.override)
    }

    func script(didStart script: Script, for cell: UITableViewCell) {
        preconditionFailure(.override)
    }

    func script(didEnd script: Script, for cell: UITableViewCell, successfully: Bool) {
        preconditionFailure(.override)
    }

    func statement(didReceive outputToken: OutputToken, for cell: UITableViewCell) {
        preconditionFailure(.override)
    }
}
