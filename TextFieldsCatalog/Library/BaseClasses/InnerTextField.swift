//
//  InnerTextField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

/// Class for UITextField with some extra features, it uses inside custom textFields in the project
final class InnerTextField: UITextField {

    // MARK: - Properties

    var pasteActionEnabled: Bool = true
    var textPadding: UIEdgeInsets = UIEdgeInsets.zero
    var placeholderPadding: UIEdgeInsets = UIEdgeInsets.zero

    // MARK: - UITextField

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if !pasteActionEnabled, action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: placeholderPadding)
    }

    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }

    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }

    // MARK: - Internal Methods

    func fixCursorPosition() {
        let beginning = beginningOfDocument
        selectedTextRange = textRange(from: beginning, to: beginning)
        let end = endOfDocument
        selectedTextRange = textRange(from: end, to: end)
    }

}
