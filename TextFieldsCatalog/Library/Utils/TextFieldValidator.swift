//
//  TextFieldValidator.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

/**
 * Class for text field validation, includes logic for validation and error text selection.
 * Contains predefined texts for errors.
 * You can add you own error text! In this case you must set text for error in public properties.
 * Or you can set global message for all errors (use 'globalErrorMessage' in constructor)
 */
final class TextFieldValidator {

    // MARK: - Constants

    private enum Constant {
        static let emptyErrorText = L10n.Errors.Textfield.empty
        static func shortErrorText(minLength: Int) -> String {
            return L10n.Errors.Textfield.short(String(minLength))
        }
        static let notValidErrorText = L10n.Errors.Textfield.notValid
    }

    // MARK: - Private Properties

    private var minLength: Int = 0
    private var maxLength: Int?
    private var regex: String?
    private var requiredField: Bool

    // MARK: - Properties

    /// Text for error, when input string does not exist
    var emptyErrorText: String?
    /// Text for error, when input string too short (< minLength)
    var shortErrorText: String?
    /// Text for error, when input string too big (> maxLength)
    var largeErrorText: String?
    /// Text for error, when input string does not match a regular expression
    var notValidErrorText: String?

    // MARK: - Initialization

    init(minLength: Int?, maxLength: Int?, regex: String?, globalErrorMessage: String? = nil, requiredField: Bool = true) {
        self.minLength = minLength ?? 0
        self.maxLength = maxLength
        self.requiredField = requiredField
        setMessageForAllErrors(globalErrorMessage)

        if let regularExpression = regex {
            do {
                _ = try NSRegularExpression(pattern: regularExpression)
                self.regex = regularExpression
            } catch let error {
                debugPrint(error)
            }
        }
    }

}

// MARK: - TextFieldValidation

extension TextFieldValidator: TextFieldValidation {

    func validate(_ text: String?) -> (isValid: Bool, errorMessage: String?) {
        guard let text = text, !text.isEmpty else {
            if self.minLength == 0 || !requiredField {
                return (true, nil)
            } else {
                return (false, textForEmptyError())
            }
        }
        if text.count < self.minLength {
            return (false, textForShortError())
        } else if let maxLength = self.maxLength, text.count > maxLength {
            return (false, textForLargeError())
        } else if let regex = self.regex {
            let matches = NSPredicate(format: "SELF MATCHES %@", regex)
            let isValid = matches.evaluate(with: text)
            if !isValid {
                return (false, textForNotValidError())
            }
        }
        return (true, nil)
    }

}

// MARK: - Error messages

private extension TextFieldValidator {

    func setMessageForAllErrors(_ message: String?) {
        emptyErrorText = message
        shortErrorText = message
        largeErrorText = message
        notValidErrorText = message
    }

    func textForEmptyError() -> String? {
        return emptyErrorText ?? Constant.emptyErrorText
    }

    func textForShortError() -> String? {
        return shortErrorText ?? Constant.shortErrorText(minLength: minLength)
    }

    func textForLargeError() -> String? {
        return largeErrorText
    }

    func textForNotValidError() -> String? {
        return notValidErrorText ?? Constant.notValidErrorText
    }

}
