//
//  SumFieldPreset.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 19/05/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit
import TextFieldsCatalog

enum SumFieldPreset: CaseIterable, AppliedPreset {
    case sum

    var name: String {
        switch self {
        case .sum:
            return "Сумма"
        }
    }

    var description: String {
        switch self {
        case .sum:
            return "Простейший пример поля для ввода суммы"
        }
    }

    func apply(for field: Any, with heightConstraint: NSLayoutConstraint) {
        guard let field = field as? SumTextField else {
            return
        }
        apply(for: field, heightConstraint: heightConstraint)
    }

}

// MARK: - Tune

private extension SumFieldPreset {

    func apply(for textField: SumTextField, heightConstraint: NSLayoutConstraint) {
        switch self {
        case .sum:
            tuneFieldForSum(textField, heightConstraint: heightConstraint)
        }
    }

    func tuneFieldForSum(_ textField: SumTextField, heightConstraint: NSLayoutConstraint) {
        textField.configure(placeholder: "Сумма")
        textField.configure(supportPlaceholder: "1 000 ₽")
        textField.configure(currencyPlaceholder: "₽")
        textField.configure(maxLength: 14)
        textField.configure(correction: .no, keyboardType: .decimalPad)
        textField.configure(heightConstraint: heightConstraint)

        let validator = TextFieldValidator(minLength: 1, maxLength: 14, regex: nil)
        textField.validator = validator

    }

}
