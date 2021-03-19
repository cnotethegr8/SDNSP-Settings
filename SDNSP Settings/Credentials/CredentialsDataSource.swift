//
//  CredentialsDataSource.swift
//  SDNS Actions
//
//  Created by Corey Werner on 31/12/2020.
//

import UIKit

enum CredentialsDataSource {
    static let sections: [SectionData<CredentialsTextFieldRowData>] = [
        SectionData(title: nil, rows: [
            CredentialsEmailRowData(),
            CredentialsPasswordRowData()
        ])
    ]

    static let cells: [IdentifiableTableViewCell.Type] = {[
        TextFieldTableViewCell.self
    ]}()
}

class CredentialsTextFieldRowData: CustomRowData {
    typealias Cell = TextFieldTableViewCell

    var title: String { preconditionFailure(.override) }

    fileprivate var textFieldText: String? {
        get { preconditionFailure(.override) }
        set { preconditionFailure(.override) }
    }

    func cell(in tableView: UITableView, for indexPath: IndexPath) -> TextFieldTableViewCell {
        let cell = dequeueReusableCell(in: tableView, for: indexPath)
        cell.textField.tag = indexPath.tag
        cell.textField.text = textFieldText
        cell.textField.autocapitalizationType = .none
        cell.textField.autocorrectionType = .no
        cell.textField.spellCheckingType = .no
        update(cell: cell)
        return cell
    }

    fileprivate func update(cell: TextFieldTableViewCell) {}

    func update(text: String?) {
        textFieldText = text
    }
}

private class CredentialsEmailRowData: CredentialsTextFieldRowData {
    override var title: String { "credentials.email".localized() }

    fileprivate override var textFieldText: String? {
        get { Keychain.shared.email }
        set { Keychain.shared.email = newValue }
    }

    fileprivate override func update(cell: TextFieldTableViewCell) {
        cell.textField.keyboardType = .emailAddress
        cell.textField.textContentType = .emailAddress
        cell.textField.returnKeyType = .next
    }
}

private class CredentialsPasswordRowData: CredentialsTextFieldRowData {
    override var title: String { "credentials.password".localized() }

    fileprivate override var textFieldText: String? {
        get { Keychain.shared.password }
        set { Keychain.shared.password = newValue }
    }

    fileprivate override func update(cell: TextFieldTableViewCell) {
        cell.textField.isSecureTextEntry = true
        cell.textField.textContentType = .password
        cell.textField.returnKeyType = .done
    }
}
