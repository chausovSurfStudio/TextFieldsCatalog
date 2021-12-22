//
//  InnerTextView.swift
//  TextFieldsCatalog
//
//  Created by Никита Гагаринов on 03.08.2021.
//

import UIKit

/// Class for UITextView with some extra features, it uses inside custom textViews in the project
public final class InnerTextView: UITextView {

    // MARK: - Private Properties

    private var disabledActions: [StandardEditActions]?

    // MARK: - UITextView

    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        guard disabledActions?.first(where: { $0.selector == action }) != nil else {
            return super.canPerformAction(action, withSender: sender)
        }
        return false
    }

    // MARK: - Internal Methods

    func disableEditActions(only actions: [StandardEditActions]?) {
        disabledActions = actions
    }

}
