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

    private var editActions: [StandardEditActions: Bool]? = nil

    // MARK: - UITextView

    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if let actions = editActions {
            for editAction in actions where editAction.key.selector == action {
                return editAction.value
            }
        }
        return super.canPerformAction(action, withSender: sender)
    }

    // MARK: - Internal Methods

    func disableEditActions(only actions: [StandardEditActions]?) {
        guard let actions = actions else {
            editActions = nil
            return
        }
        editActions = [:]
        actions.forEach {
            editActions?[$0] = false
        }
    }

}
