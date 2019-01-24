//
//  UnderlinedFieldPreset.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 24/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

enum UnderlinedFieldPreset: CaseIterable, AppliedPreset {
    case plain

    var name: String {
        switch self {
        case .plain:
            return "Введите имя"
        }
    }

    var description: String {
        switch self {
        case .plain:
            return "Тестовый пресет"
        }
    }

    func apply(for field: Any) {
        guard let field = field as? UnderlinedTextField else {
            return
        }
        apply(for: field)
    }

}

// MARK: - Tune

private extension UnderlinedFieldPreset {

    func apply(for textField: UnderlinedTextField) {
        switch self {
        case .plain:
            tuneFieldForPlain(textField)
        }
    }

    func tuneFieldForPlain(_ textField: UnderlinedTextField) {
        textField.configure(placeholder: "Введите что-нибудь", infoString: "Что душе угодно", maxLength: nil)
        textField.validator = TextFieldValidator(minLength: 1, maxLength: nil, regex: nil)
    }

}
