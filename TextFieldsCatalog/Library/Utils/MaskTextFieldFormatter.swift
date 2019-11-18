//
//  MaskTextFieldFormatter.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 28/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation
import InputMask

/// Special formatter for input field with mask (work only with text field)
public final class MaskTextFieldFormatter: NSObject {

    // MARK: - Properties

    /// Error message for case, when user leave empty text field
    public var emptyStringErrorMessage: String = L10n.Errors.Textfield.empty
    /// Error message for case, when user leave incorrect text field
    public var incorrectStringErrorMessage: String = L10n.Errors.Textfield.notValid

    // MARK: - Private Properties

    /// This is object (not delegate) for processing mask logic
    // swiftlint:disable weak_delegate
    private let maskedDelegate: MaskedTextFieldDelegate
    // swiftlint:enable weak_delegate
    /// Raw input value, which the user entered
    private var rawValue: String?
    /// Flag about entered completion (the mask is completely filled)
    private var inputIsCompleted: Bool = false

    // MARK: - Initialization

    public convenience init(mask: String) {
        self.init(mask: mask, notations: FormatterMasks.notations())
    }

    public init(mask: String, notations: [Notation]) {
        self.maskedDelegate = MaskedTextFieldDelegate(primaryFormat: mask)
        self.maskedDelegate.customNotations = notations
        super.init()
    }

    // MARK: - Internal Methods

    /// Method returns tuple with isValid flag and errorMessage, if current input state is incorrect
    public func validate() -> (isValid: Bool, errorMessage: String?) {
        if inputIsCompleted {
            return (true, nil)
        }
        if rawValue?.isEmpty == true {
            return (false, emptyStringErrorMessage)
        }
        return (false, incorrectStringErrorMessage)
    }

    /// Method for formatting passed string with initial mask
    public func format(string: String?, field: UITextField) {
        let text = string ?? ""
        maskedDelegate.put(text: text, into: field)
    }

    /// Method for formatting with current mask without field
    public func format(string: String?) -> String? {
        guard let text = string else {
            return nil
        }
        let result = maskedDelegate.primaryMask.apply(toText: CaretString(string: text, caretPosition: text.endIndex), autocomplete: true)
        return result.formattedText.string
    }

    /// Method returns object, which you must access to delegate property of needed UITextField
    public func delegateForTextField() -> UITextFieldDelegate {
        return maskedDelegate
    }

    /// Method for setting object as listener to provide processing callbacks of UITextFieldDelegate messages
    public func setListenerToFormatter(listener: MaskedTextFieldDelegateListener) {
        maskedDelegate.listener = listener
    }

}

// MARK: - MaskedTextFieldDelegateListener

extension MaskTextFieldFormatter: MaskedTextFieldDelegateListener {

    public func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        self.rawValue = value
        self.inputIsCompleted = complete
    }

}
