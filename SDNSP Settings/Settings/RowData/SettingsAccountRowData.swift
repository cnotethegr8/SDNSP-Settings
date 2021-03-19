//
//  SettingsAccountRowData.swift
//  SDNS Actions
//
//  Created by Corey Werner on 17/02/2021.
//

import UIKit

class SettingsAccountRowData: SettingsToggleRowData {
    override var title: String { "settings.row.account".localized() }
    override var isToggleEnabled: Bool { false }
    override var displayScript: Script { accountActiveScript }

    override func statement(didReceive outputToken: OutputToken, for cell: ToggleTableViewCell) {
        if let isOn = accountActiveStatement.output(for: outputToken) {
            cell.toggle.isOn = isOn
        }
    }

    private lazy var accountActiveScript = Script(endpoint: .account, statement: accountActiveStatement)

    private let accountActiveStatement = Expression<Bool>()
        .element(id: "pnlSmartDNSConfigurationStatus")
        .elements(tag: "tbody")
        .elements(tag: "tr")
        .elements(tag: "img")
        .attribute("src")
        .contains(text: "success")
}
