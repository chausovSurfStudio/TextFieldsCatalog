//
//  BorderedFieldPreset.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import TextFieldsCatalog

enum BorderedFieldPreset: CaseIterable, AppliedPreset {
    case password
    case email
    case phone
    case cardExpirationDate
    case cvc
    case cardNumber
    case qrCode

    var name: String {
        switch self {
        case .password:
            return L10n.Presets.Password.name
        case .email:
            return L10n.Presets.Email.name
        case .phone:
            return L10n.Presets.Phone.name
        case .cardExpirationDate:
            return L10n.Presets.Cardexpirationdate.name
        case .cvc:
            return L10n.Presets.Cvc.name
        case .cardNumber:
            return L10n.Presets.Cardnumber.name
        case .qrCode:
            return L10n.Presets.Qrcode.name
        }
    }

    var description: String {
        switch self {
        case .password:
            return L10n.Presets.Password.description
        case .email:
            return L10n.Presets.Email.description
        case .phone:
            return L10n.Presets.Phone.description
        case .cardExpirationDate:
            return L10n.Presets.Cardexpirationdate.description
        case .cvc:
            return L10n.Presets.Cvc.description
        case .cardNumber:
            return L10n.Presets.Cardnumber.description
        case .qrCode:
            return L10n.Presets.Qrcode.description
        }
    }

    func apply(for field: Any) {
        guard let field = field as? BorderedTextField else {
            return
        }
        apply(for: field)
    }

}

// MARK: - Tune

private extension BorderedFieldPreset {

    func apply(for textField: BorderedTextField) {
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
        case .qrCode:
            tuneFieldForQRCode(textField)
        }
    }

    func tuneFieldForPassword(_ textField: BorderedTextField) {
        textField.configure(placeholder: L10n.Presets.Password.placeholder, maxLength: nil)
        textField.configure(correction: .no, keyboardType: .asciiCapable)
        textField.disablePasteAction()
        textField.setHint(L10n.Presets.Password.hint)
        textField.setReturnKeyType(.next)
        textField.setTextFieldMode(.password)

        let validator = TextFieldValidator(minLength: 8, maxLength: 20, regex: Regex.password)
        validator.shortErrorText = L10n.Presets.Password.shortErrorText
        validator.largeErrorText = L10n.Presets.Password.largeErrorText(String(20))
        textField.validator = validator

        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.password)
    }

    func tuneFieldForEmail(_ textField: BorderedTextField) {
        textField.configure(placeholder: L10n.Presets.Email.placeholder, maxLength: nil)
        textField.configure(correction: .no, keyboardType: .emailAddress)
        textField.validator = TextFieldValidator(minLength: 1, maxLength: nil, regex: Regex.email)
    }

    func tuneFieldForPhone(_ textField: BorderedTextField) {
        textField.configure(placeholder: L10n.Presets.Phone.placeholder, maxLength: nil)
        textField.configure(correction: .no, keyboardType: .phonePad)
        textField.validator = TextFieldValidator(minLength: 18, maxLength: nil, regex: nil, globalErrorMessage: L10n.Presets.Phone.errorMessage)
        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.phone)
    }

    func tuneFieldForCardExpirationDate(_ textField: BorderedTextField) {
        textField.configure(placeholder: L10n.Presets.Cardexpirationdate.placeholder, maxLength: nil)
        textField.configure(correction: .no, keyboardType: .numberPad)
        textField.validator = TextFieldValidator(minLength: 5, maxLength: nil, regex: nil, globalErrorMessage: L10n.Presets.Cardexpirationdate.errorMessage)
        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.cardExpirationDate)
    }

    func tuneFieldForCvc(_ textField: BorderedTextField) {
        textField.configure(placeholder: L10n.Presets.Cvc.placeholder, maxLength: nil)
        textField.configure(correction: .no, keyboardType: .numberPad)
        textField.validator = TextFieldValidator(minLength: 3, maxLength: nil, regex: nil, globalErrorMessage: L10n.Presets.Cvc.errorMessage)
        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.cvc)
    }

    func tuneFieldForCardNumber(_ textField: BorderedTextField) {
        textField.configure(placeholder: L10n.Presets.Cardnumber.placeholder, maxLength: nil)
        textField.configure(correction: .no, keyboardType: .numberPad)
        textField.validator = TextFieldValidator(minLength: 19, maxLength: nil, regex: nil, globalErrorMessage: L10n.Presets.Cardnumber.errorMessage)
        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.cardNumber)
    }

    func tuneFieldForQRCode(_ textField: BorderedTextField) {
        textField.configure(placeholder: L10n.Presets.Qrcode.placeholder, maxLength: 10)
        textField.configure(correction: .no, keyboardType: .asciiCapable)
        textField.setHint(L10n.Presets.Qrcode.hint)
        textField.validator = TextFieldValidator(minLength: 10, maxLength: 10, regex: nil)

        let actionButtonConfig = ActionButtonConfiguration(image: UIImage(asset: Asset.qrCode),
                                                           normalColor: Color.Button.active,
                                                           pressedColor: Color.Button.pressed)
        textField.setTextFieldMode(.custom(actionButtonConfig))
        textField.onActionButtonTap = { _ in
            print("did tap on action button")
        }
    }

}
