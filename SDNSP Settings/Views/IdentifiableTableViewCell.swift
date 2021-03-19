//
//  IdentifiableTableViewCell.swift
//  SDNS Actions
//
//  Created by Corey Werner on 30/01/2021.
//

import UIKit

class IdentifiableTableViewCell: UITableViewCell {
    class var preferredReuseIdentifier: String { String(describing: self) }
}
