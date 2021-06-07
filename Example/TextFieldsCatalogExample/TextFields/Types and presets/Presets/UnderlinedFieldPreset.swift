//
//  UnderlinedFieldPreset.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 24/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import TextFieldsCatalog

enum UnderlinedFieldPreset: CaseIterable, AppliedPreset {
    case password
    case name
    case email
    case phone
    case cardExpirationDate
    case cvc
    case cardNumber
    case qrCode
    case birthday
    case sex

    var name: String {
        switch self {
        case .password:
            return L10n.Presets.Password.name
        case .name:
            return L10n.Presets.Name.name
        case .email:
            return L10n.Presets.Email.name
        case .phone:
            return L10n.Presets.Phone.name
        case .cardExpirationDate:
            return L10n.Presets.CardExpirationDate.name
        case .cvc:
            return L10n.Presets.Cvc.name
        case .cardNumber:
            return L10n.Presets.CardNumber.name
        case .qrCode:
            return L10n.Presets.QrCode.name
        case .birthday:
            return L10n.Presets.Birthday.name
        case .sex:
            return L10n.Presets.Sex.name
        }
    }

    var description: String {
        switch self {
        case .password:
            return L10n.Presets.Password.description
        case .name:
            return L10n.Presets.Name.description
        case .email:
            return L10n.Presets.Email.description
        case .phone:
            return L10n.Presets.Phone.description
        case .cardExpirationDate:
            return L10n.Presets.CardExpirationDate.description
        case .cvc:
            return L10n.Presets.Cvc.description
        case .cardNumber:
            return L10n.Presets.CardNumber.description
        case .qrCode:
            return L10n.Presets.QrCode.description
        case .birthday:
            return L10n.Presets.Birthday.description
        case .sex:
            return L10n.Presets.Sex.description
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
        case .name:
            tuneFieldForName(textField)
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
        case .qrCode:
            tuneFieldForQRCode(textField)
        case .birthday:
            tuneFieldForBirthday(textField)
        case .sex:
            tuneFieldForSex(textField)
        }
    }

    func tuneFieldForPassword(_ textField: UnderlinedTextField) {
        textField.placeholder = L10n.Presets.Password.placeholder
        textField.field.autocorrectionType = .no
        textField.field.keyboardType = .asciiCapable
        textField.field.returnKeyType = .next
        textField.field.pasteActionEnabled = false
        textField.mode = .password(.visibleOnNotEmptyText)
        textField.setup(hint: L10n.Presets.Password.hint)

        let validator = TextFieldValidator(minLength: 8, maxLength: 20, regex: SharedRegex.password)
        validator.shortErrorText = L10n.Presets.Password.shortErrorText
        validator.largeErrorText = L10n.Presets.Password.largeErrorText(String(20))
        textField.validator = validator

        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.password)
    }

    func tuneFieldForName(_ textField: UnderlinedTextField) {
        textField.placeholder = L10n.Presets.Name.placeholder
        textField.field.autocorrectionType = .no
        textField.field.autocapitalizationType = .words
        textField.maxLength = 20
        textField.setup(hint: L10n.Presets.Name.hint)
        textField.trimSpaces = true
        textField.setup(visibleHintStates: [.normal, .active, .error])
        textField.pasteAllowedChars = true
        textField.pasteOverflowPolicy = .textThatFits
        textField.allowedCharacterSet = CharacterSet.letters
            .union(.decimalDigits)
            .union(.whitespacesAndNewlines)
            .union(.init(charactersIn: "№!@#$%^&*()_+1234567890-=><?.,\'\"`«»„“”;:[]{}₽–—`‘/\\"))

//        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.name, notations: FormatterMasks.customNotations())

        let validator = TextFieldValidator(minLength: 1, maxLength: 20, regex: SharedRegex.name)
        validator.notValidErrorText = L10n.Presets.Name.notValidError
        validator.largeErrorText = L10n.Presets.Name.largeTextError
        textField.validator = validator
    }

    func tuneFieldForEmail(_ textField: UnderlinedTextField) {
        textField.placeholder = L10n.Presets.Email.placeholder
        textField.validator = TextFieldValidator(minLength: 1, maxLength: nil, regex: SharedRegex.email)
        textField.field.autocorrectionType = .no
        textField.field.keyboardType = .emailAddress
    }

    func tuneFieldForPhone(_ textField: UnderlinedTextField) {
        textField.placeholder = L10n.Presets.Phone.placeholder
        textField.validator = TextFieldValidator(minLength: 18, maxLength: nil, regex: nil, globalErrorMessage: L10n.Presets.Phone.errorMessage)
        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.phone)
        textField.field.autocorrectionType = .no
        textField.field.keyboardType = .phonePad
    }

    func tuneFieldForCardExpirationDate(_ textField: UnderlinedTextField) {
        textField.placeholder = L10n.Presets.CardExpirationDate.placeholder
        textField.validator = TextFieldValidator(minLength: 5,
                                                 maxLength: nil,
                                                 regex: nil,
                                                 globalErrorMessage: L10n.Presets.CardExpirationDate.errorMessage)
        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.cardExpirationDate)
        textField.field.autocorrectionType = .no
        textField.field.keyboardType = .numberPad
    }

    func tuneFieldForCvc(_ textField: UnderlinedTextField) {
        textField.placeholder = L10n.Presets.Cvc.placeholder
        textField.validator = TextFieldValidator(minLength: 3,
                                                 maxLength: nil,
                                                 regex: nil,
                                                 globalErrorMessage: L10n.Presets.Cvc.errorMessage)
        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.cvc)
        textField.field.autocorrectionType = .no
        textField.field.keyboardType = .numberPad
        textField.toolbar = PickerTopView.default()
    }

    func tuneFieldForCardNumber(_ textField: UnderlinedTextField) {
        textField.placeholder = L10n.Presets.CardNumber.placeholder
        textField.validator = TextFieldValidator(minLength: 19,
                                                 maxLength: nil,
                                                 regex: nil,
                                                 globalErrorMessage: L10n.Presets.CardNumber.errorMessage)
        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.cardNumber)
        textField.field.autocorrectionType = .no
        textField.field.keyboardType = .numberPad
    }

    func tuneFieldForQRCode(_ textField: UnderlinedTextField) {
        textField.placeholder = L10n.Presets.QrCode.placeholder
        textField.validator = TextFieldValidator(minLength: 10, maxLength: 10, regex: nil)
        textField.field.autocorrectionType = .no
        textField.field.keyboardType = .asciiCapable
        textField.maxLength = 10
        textField.setup(hint: L10n.Presets.QrCode.hint)

        let actionButtonConfig = ActionButtonConfiguration(image: UIImage(asset: Asset.qrCode),
                                                           normalColor: Color.Button.active,
                                                           pressedColor: Color.Button.pressed)
        textField.mode = .custom(actionButtonConfig)
        textField.onActionButtonTap = { field, _ in
            field.text = "12 345-678"
        }

        if let boxTextField = textField as? BoxTextField {
            boxTextField.configure(supportPlaceholder: "XX XXX-XXX")
        } else if type(of: textField) == UnderlinedTextField.self {
            textField.setup(supportPlaceholder: "XX XXX-XXX")
        }
    }

    func tuneFieldForBirthday(_ textField: UnderlinedTextField) {
        textField.placeholder = L10n.Presets.Birthday.placeholder
        textField.validator = TextFieldValidator(minLength: 1,
                                                 maxLength: nil,
                                                 regex: nil,
                                                 globalErrorMessage: L10n.Presets.Birthday.hint)
        textField.field.inputView = DatePickerView.default(for: textField)

        textField.onDateChanged = { date in
            print("this is selected date - \(date)")
        }
    }

    func tuneFieldForSex(_ textField: UnderlinedTextField) {
        textField.placeholder = L10n.Presets.Sex.placeholder
        textField.validator = TextFieldValidator(minLength: 1,
                                                 maxLength: nil,
                                                 regex: nil,
                                                 globalErrorMessage: L10n.Presets.Sex.hint)
        textField.field.inputView = PlainPickerView.default(for: textField,
                                                            data: Sex.allCases.map { $0.value })

        textField.onTextChanged = { field in
            if let value = Sex.sex(by: field.text) {
                print(value)
            } else {
                print("sex is undefined")
            }
        }
    }

}
