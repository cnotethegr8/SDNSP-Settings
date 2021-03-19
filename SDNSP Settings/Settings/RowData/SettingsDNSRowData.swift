//
//  SettingsDNSRowData.swift
//  SDNS Actions
//
//  Created by Corey Werner on 17/02/2021.
//

import UIKit

class SettingsDNSRowData: SettingsToggleRowData {
    override var title: String { "settings.row.dns".localized() }
    override var isToggleEnabled: Bool { false }
    override var displayScript: Script { dnsActiveScript }

    override func statement(didReceive outputToken: OutputToken, for cell: ToggleTableViewCell) {
        if let isOn = dnsActiveStatement.output(for: outputToken) {
            cell.toggle.isOn = isOn
        }
    }

    private lazy var dnsActiveScript = Script(endpoint: .account, statement: dnsActiveStatement)

    private let dnsActiveStatement = Expression<Bool>()
        .element(id: "dnsactivationstatusicon")
        .elements(tag: "img")
        .attribute("src")
        .contains(text: "success")
}
