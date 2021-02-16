//
//  UnderlinedTextViewPreset.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 27/05/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import TextFieldsCatalog

enum UnderlinedTextViewPreset: CaseIterable, AppliedPreset {
    case comment

    var name: String {
        switch self {
        case .comment:
            return L10n.Presets.Comment.name
        }
    }

    var description: String {
        switch self {
        case .comment:
            return L10n.Presets.Comment.description
        }
    }

    func apply(for field: Any) {
        guard let field = field as? UnderlinedTextView else {
            return
        }
        apply(for: field)
    }

}

// MARK: - Tune

private extension UnderlinedTextViewPreset {

    func apply(for textView: UnderlinedTextView) {
        switch self {
        case .comment:
            tuneFieldForComment(textView)
        }
    }

    func tuneFieldForComment(_ textView: UnderlinedTextView) {
        textView.placeholder = L10n.Presets.Comment.placeholder
        textView.maxLength = 200
        textView.maxTextContainerHeight = 96
        textView.field.autocorrectionType = .no
        textView.setup(hint: L10n.Presets.Comment.hint)

        let validator = TextFieldValidator(minLength: 30, maxLength: 200, regex: nil)
        validator.shortErrorText = L10n.Presets.Comment.errorMessage
        textView.validator = validator
    }

}
