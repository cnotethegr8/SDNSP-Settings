//
//  DataSource.swift
//  SDNS Actions
//
//  Created by Corey Werner on 31/12/2020.
//

import UIKit

struct SectionData<Row> {
    let title: String?
    let rows: [Row]
}

protocol RowData {
    func cell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
}

protocol CustomRowData {
    associatedtype Cell: IdentifiableTableViewCell

    var title: String { get }
    func cell(in tableView: UITableView, for indexPath: IndexPath) -> Cell
}

extension CustomRowData {
    func dequeueReusableCell(in tableView: UITableView, for indexPath: IndexPath) -> Cell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.preferredReuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Cell type does not match cell identifier")
        }

        cell.textLabel?.text = title
        return cell
    }
}
