//
//  SettingsDataSource.swift
//  SDNS Actions
//
//  Created by Corey Werner on 15/01/2021.
//

import UIKit

enum SettingsDataSource {
    static let sections: [SectionData<SettingsRowData>] = [
        SectionData(title: "settings.section.account".localized(), rows: [
            SettingsAccountRowData(),
            SettingsDNSRowData(),
            SettingsIPRowData()
        ]),
        SectionData(title: "settings.section.region".localized(), rows: [
            SettingsNetflixRowData()
        ])
    ]

    static let cells: [IdentifiableTableViewCell.Type] = {[
        ToggleTableViewCell.self
    ]}()
}
