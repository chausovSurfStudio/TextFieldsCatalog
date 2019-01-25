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
    case cardExpirationDate
    case cvc
    case cardNumber

    var name: String {
        switch self {
        case .password:
            return "Пароль"
        case .email:
            return "Email"
        case .phone:
            return "Номер телефона"
        case .cardExpirationDate:
            return "Срок действия карты"
        case .cvc:
            return "CVC-код"
        case .cardNumber:
            return "Номер карты"
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
        case .cardExpirationDate:
            return "Пример поля ввода поля для срока окончания действия карты"
        case .cvc:
            return "Пример поля для ввода CVC-кода карты"
        case .cardNumber:
            return "Пример поля для ввода номера карты"
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
        case .cardExpirationDate:
            tuneFieldForCardExpirationDate(textField)
        case .cvc:
            tuneFieldForCvc(textField)
        case .cardNumber:
            tuneFieldForCardNumber(textField)
        }
    }

    func tuneFieldForPassword(_ textField: UnderlinedTextField) {
        textField.configure(placeholder: L10n.Presets.Borderedfield.Password.placeholder, maxLength: nil)
        textField.configure(correction: .no, keyboardType: .asciiCapable)
        textField.disablePasteAction()
        textField.setHint(L10n.Presets.Borderedfield.Password.hint)
        textField.setReturnKeyType(.next)
        textField.setTextFieldMode(.password)

        let validator = TextFieldValidator(minLength: 8, maxLength: 20, regex: Regex.password)
        validator.shortErrorText = L10n.Presets.Borderedfield.Password.shortErrorText
        validator.largeErrorText = "Пароль должен содержать не более 20 символов"
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
        textField.validator = TextFieldValidator(minLength: 18, maxLength: nil, regex: nil, globalErrorMessage: "Номер телефона должен содержать 10 цифр")
        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.phone)
    }

    func tuneFieldForCardExpirationDate(_ textField: UnderlinedTextField) {
        textField.configure(placeholder: "Срок действия карты", maxLength: nil)
        textField.configure(correction: .no, keyboardType: .numberPad)
        textField.validator = TextFieldValidator(minLength: 5, maxLength: nil, regex: nil, globalErrorMessage: "Введите месяц и год окончания срока действия")
        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.cardExpirationDate)
    }

    func tuneFieldForCvc(_ textField: UnderlinedTextField) {
        textField.configure(placeholder: "CVC", maxLength: nil)
        textField.configure(correction: .no, keyboardType: .numberPad)
        textField.validator = TextFieldValidator(minLength: 3, maxLength: nil, regex: nil, globalErrorMessage: "CVC-код должен содержать 3 цифры")
        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.cvc)
    }

    func tuneFieldForCardNumber(_ textField: UnderlinedTextField) {
        textField.configure(placeholder: "Номер карты", maxLength: nil)
        textField.configure(correction: .no, keyboardType: .numberPad)
        textField.validator = TextFieldValidator(minLength: 19, maxLength: nil, regex: nil, globalErrorMessage: "Введите правильно номер Вашей карты")
        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.cardNumber)
    }

}
