//
//  BorderedFieldPreset.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

enum BorderedFieldPreset: CaseIterable {
    case password

    var name: String {
        switch self {
        case .password:
            return "Пароль"
        }
    }

    var description: String {
        switch self {
        case .password:
            return "Типичный кейс для ввода пароля. Здесь должно быть подробное описание"
        }
    }

    func apply(for textField: BorderedTextField) {
        switch self {
        case .password:
            tuneFieldForPassword(textField)
        }
    }
}

private extension BorderedFieldPreset {

    func tuneFieldForPassword(_ textField: BorderedTextField) {
        textField.configure(placeholder: "Пароль", maxLength: nil)
        textField.configure(correction: .no, keyboardType: .asciiCapable)
        textField.disablePasteAction()
        textField.setHint("Текст подсказки")
        textField.setReturnKeyType(.next)
        textField.setTextFieldMode(.password)

        let validator = TextFieldValidator(minLength: 8, maxLength: 20, regex: Regex.password)
        validator.shortErrorText = "Пароль слишком короткий"
        textField.validator = validator

        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.password)
    }

}
