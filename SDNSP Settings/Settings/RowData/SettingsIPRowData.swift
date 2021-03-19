//
//  SettingsIPRowData.swift
//  SDNS Actions
//
//  Created by Corey Werner on 17/02/2021.
//

import UIKit

class SettingsIPRowData: SettingsToggleRowData {
    override var title: String { "settings.row.ip".localized() }
    override var isToggleEnabled: Bool { false }
    override var displayScript: Script { ipScript }

    override func statement(didReceive outputToken: OutputToken, for cell: ToggleTableViewCell) {
        if let isOn = ipActiveStatement.output(for: outputToken) {
            cell.toggle.isOn = isOn
        }
        else if let text = ipAddressStatement.output(for: outputToken) {
            cell.detailTextLabel?.text = text
        }
    }

    private lazy var ipScript = Script(endpoint: .account, statement: ArrayStatement([
        ipActiveStatement,
        ipAddressStatement
    ]))

    private let ipActiveStatement = Expression<Bool>()
        .element(id: "ipactivationstatusicon")
        .elements(tag: "img")
        .attribute("src")
        .contains(text: "success")

    private let ipAddressStatement = Expression<String>()
        .element(id: "ipactivationinfo")
        .elements(tag: "strong")
        .text()
}
