//
//  SettingsToggleRowData.swift
//  SDNS Actions
//
//  Created by Corey Werner on 17/02/2021.
//

import UIKit

class SettingsToggleRowData: SettingsRowData, CustomRowData {
    typealias Cell = ToggleTableViewCell

    var title: String { preconditionFailure(.override) }
    var isToggleEnabled: Bool { true }

    override func cell(in tableView: UITableView, for indexPath: IndexPath) -> ToggleTableViewCell {
        let cell = dequeueReusableCell(in: tableView, for: indexPath)
        cell.toggle.isEnabled = isToggleEnabled
        return cell
    }

    override func script(didStart script: Script, for cell: UITableViewCell) {
        if let cell = cell as? Cell {
            self.script(didStart: script, for: cell)
        }
    }

    override func script(didEnd script: Script, for cell: UITableViewCell, successfully: Bool) {
        if let cell = cell as? Cell {
            self.script(didEnd: script, for: cell, successfully: successfully)
        }
    }

    override func statement(didReceive outputToken: OutputToken, for cell: UITableViewCell) {
        if let cell = cell as? Cell {
            statement(didReceive: outputToken, for: cell)
        }
    }

    func script(didStart script: Script, for cell: ToggleTableViewCell) {}

    func script(didEnd script: Script, for cell: ToggleTableViewCell, successfully: Bool) {}

    func statement(didReceive outputToken: OutputToken, for cell: ToggleTableViewCell) {
        preconditionFailure(.override)
    }
}
