//
//  ToggleTableViewCell.swift
//  SDNS Actions
//
//  Created by Corey Werner on 15/01/2021.
//

import UIKit

class ToggleTableViewCell: IdentifiableTableViewCell {
    let toggle = UISwitch()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)

        accessoryView = toggle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        detailTextLabel?.text = nil

        toggle.isEnabled = true
        toggle.isOn = false
    }
}
