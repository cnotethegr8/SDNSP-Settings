//
//  SettingsNetflixRowData.swift
//  SDNS Actions
//
//  Created by Corey Werner on 17/02/2021.
//

import UIKit

class SettingsNetflixRowData: SettingsToggleRowData {
    override var title: String { "settings.row.netflix".localized() }
    override var displayScript: Script { netflixActiveScript }
    override var actionScript: Script? { netflixRegionScript }

    override func script(didStart script: Script, for cell: ToggleTableViewCell) {
        if script == actionScript {
            cell.detailTextLabel?.text = "common.updating".localized()
            cell.toggle.isEnabled = false
        }
    }

    override func script(didEnd script: Script, for cell: ToggleTableViewCell, successfully: Bool) {
        if script == actionScript {
            cell.detailTextLabel?.text = nil
            cell.toggle.isEnabled = true

            if !successfully {
                cell.toggle.setOn(!cell.toggle.isOn, animated: true)
            }
        }
    }

    override func statement(didReceive outputToken: OutputToken, for cell: ToggleTableViewCell) {
        if let isOn = netflixActiveStatement.output(for: outputToken) {
            cell.toggle.isOn = isOn
        }
        else if let isOn = netflixRegionActiveStatement.output(for: outputToken) {
            cell.toggle.isOn = isOn
        }
    }

    // MARK: Display

    private lazy var netflixActiveScript = Script(endpoint: .account, statement: netflixActiveStatement)

    private let netflixActiveStatement = Expression<Bool>()
        .element(id: "netflix_region")
        .text()
        .excludes(text: "Off")

    // MARK: Action

    private let netflixRegionOnID = "ContentPlaceHolderMain_netflix_on"

    private lazy var netflixRegionActiveStatement = Expression<Bool>()
        .element(id: netflixRegionOnID)
        .contains(class: "active")

    private lazy var netflixRegionScript: Script = {
        let toggleRegionStatement = Statement()
            .element(id: netflixRegionOnID)
            .parent()
            .query(":not(.active)")
            .click()

        let script = Script(endpoint: .region)
        script.addStatement(toggleRegionStatement)
        script.addWaitForReload()
        script.addStatement(netflixRegionActiveStatement)
        return script
    }()
}
