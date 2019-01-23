//
//  BorderedTextField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import InputMask

/// Class for custom textField. Default height equals to 130.
final class BorderedTextField: DesignableView {

    // MARK: - Enums

    private enum BorderedTextFieldState {
        /// textField not in focus
        case normal
        /// state for active textField
        case active
        /// state for disabled textField
        case disabled
    }

    enum BorderedTextFieldMode {
        /// normal textField mode without any action buttons
        case plain
        /// mode for password textField
        case password
        /// mode for textField with qr-code button
        case qr
    }

    // MARK: - Constants

    private enum Constants {
        static let animationDuration: TimeInterval = 0.3
        static let defaultTextPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let increasedTextPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 56)
        static let textFieldBorderWidth: CGFloat = 2
        static let textFieldCornerRadius: CGFloat = 6
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var textField: InnerTextField!
    @IBOutlet private weak var actionButton: IconButton!
    @IBOutlet private weak var hintLabel: UILabel!

    // MARK: - Private Properties

    private var state: BorderedTextFieldState = .normal {
        didSet(newValue) {
            updateUI()
        }
    }
    private var maxLength: Int?
    private var hintMessage: String?
    private var error: Bool = false
    private var mode: BorderedTextFieldMode = .plain
    private var nextInput: UIResponder?

    // MARK: - Properties

    var validator: TextFieldValidation?
    var maskFormatter: MaskTextFieldFormatter? {
        didSet {
            textField.delegate = maskFormatter?.delegateForTextField()
            maskFormatter?.setListenerToFormatter(listener: self)
            textField.autocorrectionType = .no
        }
    }
    var hideOnReturn: Bool = true
    var validateWithFormatter: Bool = false

    var onBeginEditing: ((BorderedTextField) -> Void)?
    var onEndEditing: ((BorderedTextField) -> Void)?
    var onTextChanged: ((BorderedTextField) -> Void)?
    var onShouldReturn: ((BorderedTextField) -> Void)?
    var onActionButtonTap: ((BorderedTextField) -> Void)?
    var onValidateFail: ((BorderedTextField) -> Void)?

    var responder: UIResponder {
        return self.textField
    }

    // MARK: - UIView

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
        updateUI()
    }

    // MARK: - Internal Methods

    /// Method for configure text field with placeholder and max length for input string
    func configure(placeholder: String?, maxLength: Int?) {
        self.placeholderLabel.text = placeholder
        self.maxLength = maxLength
    }

    /// Allows you to set autocorrection and keyboardType for textField
    func configure(correction: UITextAutocorrectionType?, keyboardType: UIKeyboardType?) {
        if let correction = correction {
            textField.autocorrectionType = correction
        }
        if let keyboardType = keyboardType {
            textField.keyboardType = keyboardType
        }
    }

    /// Allows you to change current mode
    func setTextFieldMode(_ mode: BorderedTextFieldMode) {
        self.mode = mode
        switch mode {
        case .plain:
            actionButton.isHidden = true
            textField.isSecureTextEntry = false
            textField.textPadding = Constants.defaultTextPadding
        case .password:
            actionButton.isHidden = false
            textField.isSecureTextEntry = true
            textField.textPadding = Constants.increasedTextPadding
            updatePasswordVisibilityButton()
        case .qr:
            actionButton.isHidden = false
            textField.isSecureTextEntry = false
            textField.textPadding = Constants.increasedTextPadding
            actionButton.setImageForAllState(UIImage(named: "qrCode"))
        }
    }

    /// Allows you to set text in textField and update all UI elements
    func setText(_ text: String?) {
        if let formatter = maskFormatter {
            formatter.format(string: text, field: textField)
        } else {
            textField.text = text
        }
        validate()
        updateUI()
    }

    /// Return current input string in textField
    func currentText() -> String? {
        return textField.text
    }

    /// Allows to set view in 'error' state, optionally allows you to set the error message. If errorMessage is nil - label keeps the previous hint message
    func setError(with errorMessage: String?) {
        error = true
        if let message = errorMessage {
            hintLabel.text = message
        }
        updateUI()
    }

    /// Allows you to know current state: return true in case of current state is valid
    @discardableResult
    func isValidState(forceValidate: Bool = false) -> Bool {
        if !error || forceValidate {
            // case if user didn't activate this text field (or you want force validate it)
            validate()
            updateUI()
        }
        return !error
    }

    /// Clear text, reset error and update all UI elements - reset to default state
    func reset() {
        textField.text = ""
        error = false
        updateUI()
    }

    /// Reset only error state and update all UI elements
    func resetErrorState() {
        error = false
        updateUI()
    }

    /// Allows you to disable paste action for textField
    func disablePasteAction() {
        textField.pasteActionEnabled = false
    }

    /// Allows you to disable textField
    func disableTextField(_ disable: Bool) {
        state = disable ? .disabled : .normal
        textField.isEnabled = !disable
        updateUI()
    }

    /// Return true if current state allows you to interact with this field
    func isEnabled() -> Bool {
        return state != .disabled
    }

    /// Allows you to set some string as hint message
    func setHint(_ hint: String) {
        guard !hint.isEmpty else {
            return
        }
        hintMessage = hint
        hintLabel.text = hint
    }

    /// Return true, if field is current firstResponder
    func isCurrentFirstResponder() -> Bool {
        return textField.isFirstResponder
    }

    /// Allows you to set next textField and go to him on return keyboard button tap
    func setNextResponder(_ nextResponder: UIResponder) {
        textField.returnKeyType = .next
        nextInput = nextResponder
    }

    /// Makes textField is current first responder
    func makeFirstResponder() {
        _ = textField.becomeFirstResponder()
    }

    /// Allows you to manage keyboard returnKeyType
    func setReturnKeyType(_ type: UIReturnKeyType) {
        textField.returnKeyType = type
    }

}

// MARK: - Configure

private extension BorderedTextField {

    func configureAppearance() {
        configureBackground()
        configurePlaceholder()
        configureTextField()
        configureHintLabel()
        configureActionButton()
    }

    func configureBackground() {
        view.backgroundColor = Color.Main.background
    }

    func configurePlaceholder() {
        placeholderLabel.textColor = Color.Text.gray
        placeholderLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        placeholderLabel.text = ""
    }

    func configureTextField() {
        textField.delegate = maskFormatter?.delegateForTextField() ?? self
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.textColor = Color.Text.white
        textField.tintColor = Color.Main.active

        textField.layer.borderColor = Color.Main.container.cgColor
        textField.layer.borderWidth = Constants.textFieldBorderWidth
        textField.layer.cornerRadius = Constants.textFieldCornerRadius
        textField.backgroundColor = Color.Main.background
        textField.textPadding = Constants.defaultTextPadding

        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(textFieldEditingChange(_:)), for: .editingChanged)
    }

    func configureHintLabel() {
        hintLabel.textColor = Color.Text.red
        hintLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        hintLabel.text = ""
        hintLabel.alpha = 0
    }

    func configureActionButton() {
        actionButton.isHidden = true
    }

}

// MARK: - Actions

private extension BorderedTextField {

    @IBAction func tapOnActionButton(_ sender: UIButton) {
        onActionButtonTap?(self)
        textField.isSecureTextEntry.toggle()
        textField.fixCursorPosition()
        updatePasswordVisibilityButton()
    }

    @objc
    func textFieldEditingChange(_ textField: UITextField) {
        removeError()
        onTextChanged?(self)
    }

}

// MARK: - UITextFieldDelegate

extension BorderedTextField: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        state = .active
        onBeginEditing?(self)
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        validate()
        state = .normal
        onEndEditing?(self)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let textRange = Range(range, in: text), !validateWithFormatter else {
            return true
        }

        let newText = text.replacingCharacters(in: textRange, with: string)
        var isValid = true
        if let maxLength = self.maxLength {
            isValid = newText.count <= maxLength
        }

        return isValid
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = nextInput {
            nextField.becomeFirstResponder()
        } else {
            if hideOnReturn {
                textField.resignFirstResponder()
            }
            onShouldReturn?(self)
            return true
        }
        return false
    }

}

// MARK: - MaskedTextFieldDelegateListener

extension BorderedTextField: MaskedTextFieldDelegateListener {

    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        maskFormatter?.textField(textField, didFillMandatoryCharacters: complete, didExtractValue: value)
        removeError()
        onTextChanged?(self)
    }

}

// MARK: - Private Methods

private extension BorderedTextField {

    func updateUI() {
        updateHintLabelColor()
        updateHintLabelVisibility()
        updateTextColor()
        updateTextFieldBorderColor()
    }

    func updatePasswordVisibilityButton() {
        guard mode == .password else {
            return
        }
        let isSecure = textField.isSecureTextEntry
        let image = isSecure ? UIImage(named: "eyeOff") : UIImage(named: "eyeOn")
        actionButton.setImageForAllState(image)
    }

    func shouldShowHint() -> Bool {
        return (state == .active && hintMessage != nil) || error
    }

    func validate() {
        if let formatter = maskFormatter, validateWithFormatter {
            let (isValid, errorMessage) = formatter.validate()
            error = !isValid
            if let message = errorMessage, !isValid {
                hintLabel.text = message
            }
        } else if let currentValidator = validator {
            let (isValid, errorMessage) = currentValidator.validate(textField.text)
            error = !isValid
            if let message = errorMessage, !isValid {
                hintLabel.text = message
            }
        }
        if error {
            onValidateFail?(self)
        }
    }

    func removeError() {
        if error {
            hintLabel.text = hintMessage
            error = false
            updateUI()
        }
    }

}

// MARK: - Updating

private extension BorderedTextField {

    func updateHintLabelColor() {
        hintLabel.textColor = hintTextColor()
    }

    func updateHintLabelVisibility() {
        let alpha: CGFloat = shouldShowHint() ? 1 : 0
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.hintLabel.alpha = alpha
        }
    }

    func updateTextColor() {
        textField.textColor = textColor()
    }

    func updateTextFieldBorderColor() {
        let startColor: CGColor = currentTextFieldBorderColor()
        let endColor: CGColor = textFieldBorderColor()
        textField.layer.borderColor = endColor

        let colorAnimation = CABasicAnimation(keyPath: "borderColor")
        colorAnimation.fromValue = startColor
        colorAnimation.toValue = endColor
        colorAnimation.duration = Constants.animationDuration
        colorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        textField.layer.add(colorAnimation, forKey: nil)
    }

}

// MARK: - Computed Colors

private extension BorderedTextField {

    func hintTextColor() -> UIColor {
        return error ? Color.Text.red : Color.Text.gray
    }

    func textColor() -> UIColor {
        return Color.Text.white
    }

    func currentTextFieldBorderColor() -> CGColor {
        return textField.layer.borderColor ?? Color.Main.container.cgColor
    }

    func textFieldBorderColor() -> CGColor {
        if error {
            return Color.Main.red.cgColor
        } else {
            switch state {
            case .active:
                return Color.Main.active.cgColor
            case .disabled, .normal:
                return Color.Main.container.cgColor
            }
        }
    }

}

