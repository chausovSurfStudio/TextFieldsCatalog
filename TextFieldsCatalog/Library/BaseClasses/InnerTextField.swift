//
//  InnerTextField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 28/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

/// Class for UITextField with some extra features, it uses inside custom textFields in the project
public final class InnerTextField: UITextField {

    // MARK: - Properties

    public var pasteActionEnabled: Bool = true
    public var textPadding: UIEdgeInsets = UIEdgeInsets.zero
    public var placeholderPadding: UIEdgeInsets = UIEdgeInsets.zero

    // MARK: - UIView

    override public init(frame: CGRect) {
        super.init(frame: frame)
        removeRightView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        removeRightView()
    }

    // MARK: - UITextField

    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
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

    // MARK: - Internal Methods

    public func fixCursorPosition() {
        let beginning = beginningOfDocument
        selectedTextRange = textRange(from: beginning, to: beginning)
        let end = endOfDocument
        selectedTextRange = textRange(from: end, to: end)
    }

}

// MARK: - Private Methods

private extension InnerTextField {

    func removeRightView() {
        rightView = UIView(frame: CGRect.zero)
    }

}
