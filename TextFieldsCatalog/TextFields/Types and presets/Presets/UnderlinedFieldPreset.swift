//
//  UnderlinedFieldPreset.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 24/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

enum UnderlinedFieldPreset: CaseIterable, AppliedPreset {
    case password
    case email
    case phone

    var name: String {
        switch self {
        case .password:
            return "Пароль"
        case .email:
            return "Email"
        case .phone:
            return "Номер телефона"
        }
    }

    var description: String {
        switch self {
        case .password:
            return "Пример поля ввода для пароля"
        case .email:
            return "Пример поля ввода для email"
        case .phone:
            return "Пример поля ввода для номера телефона"
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
        case .password:
            tuneFieldForPassword(textField)
        case .email:
            tuneFieldForEmail(textField)
        case .phone:
            tuneFieldForPhone(textField)
        }
    }

    func tuneFieldForPassword(_ textField: UnderlinedTextField) {
        textField.configure(placeholder: L10n.Presets.Borderedfield.Password.placeholder, maxLength: nil)
        textField.configure(correction: .no, keyboardType: .asciiCapable)
        textField.disablePasteAction()
        textField.setHint(L10n.Presets.Borderedfield.Password.hint)
        textField.setTextFieldMode(.password)

        let validator = TextFieldValidator(minLength: 8, maxLength: 20, regex: Regex.password)
        validator.shortErrorText = L10n.Presets.Borderedfield.Password.shortErrorText
        textField.validator = validator

        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.password)
    }

    func tuneFieldForEmail(_ textField: UnderlinedTextField) {
        textField.configure(placeholder: L10n.Presets.Borderedfield.Email.placeholder, maxLength: nil)
        textField.configure(correction: .no, keyboardType: .emailAddress)
        textField.validator = TextFieldValidator(minLength: 1, maxLength: nil, regex: Regex.email)
    }

    func tuneFieldForPhone(_ textField: UnderlinedTextField) {
        textField.configure(placeholder: "Номер телефона", maxLength: nil)
        textField.configure(correction: .no, keyboardType: .phonePad)
        textField.validator = TextFieldValidator(minLength: 18, maxLength: 18, regex: nil, globalErrorMessage: "Номер телефона должен содержать 10 цифр")
        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.phone)
    }

}
