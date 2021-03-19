//
//  TextFieldTableViewCell.swift
//  SDNS Actions
//
//  Created by Corey Werner on 30/11/2020.
//

import UIKit

class TextFieldTableViewCell: IdentifiableTableViewCell {
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        accessoryView = textField
        return textField
    }()

    // MARK: Layout

    private var textLabelWidth: CGFloat = 0

    override func layoutSubviews() {
        super.layoutSubviews()

        if textLabelWidth == 0 {
            textLabelWidth = ceil(textLabel?.attributedText?.boundingRect(with: bounds.size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).width ?? 0)
        }

        let margin: CGFloat = 16

        var frame = textField.frame
        frame.size.width = bounds.width - layoutMargins.left - margin - textLabelWidth - layoutMargins.right
        frame.size.height = bounds.height
        frame.origin.x = bounds.width - layoutMargins.right - frame.width
        frame.origin.y = 0
        textField.frame = frame
    }

    // MARK: Interaction

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        if textField.isEnabled && !textField.isFirstResponder {
            textField.becomeFirstResponder()
        }
    }
}
