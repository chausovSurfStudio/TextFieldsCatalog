//
//  UnderlinedTextField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 24/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import SurfUtils

/**
 * Class for custom textField. Contains UITextFiled, top floating placeholder, underline line under textField and bottom label with some info.
 * Standart height equals 77. Colors, fonts and offsets do not change, they are protected inside (for now =))
 */
final class UnderlinedTextField: DesignableView {

    private enum UnderlinedTextFieldState: Int {
        /// textField not in focus
        case normal
        /// state with active textField
        case active
        /// state for disabled textField
        case disabled
    }

    enum UnderlinedTextFieldMode: Int {
        /// standart mode without any changes
        case plain
        /// the button with the eye is added, the symbols are replaced with the stars.
        case password
    }

    // MARK: - Constants

    private enum Constant {
        static let animationDuration: Double = 0.3
        static let topPlaceholderVisibleOffset: CGFloat = 0
        static let topPlaceholderHiddenOffset: CGFloat = 5
        static let smallSeparatorHeight: CGFloat = 1
        static let bigSeparatorHeight: CGFloat = 2
        static let smallTextFieldLeftOffset: CGFloat = 16
        static let bigTextFieldLeftOffset: CGFloat = 38
        static let placeholderOnTopColorAlpha: CGFloat = 0.4
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var topPlaceholderLabel: UILabel!
    @IBOutlet private weak var textfield: InnerTextField!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var bottomInfoLabel: UILabel!
    @IBOutlet private weak var eyeButton: UIButton!

    @IBOutlet private weak var placeholderTopOffsetConstraint: NSLayoutConstraint!
    @IBOutlet private weak var separatorViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textFieldLeftOffsetConstraint: NSLayoutConstraint!

    // MARK: - Private Properties

    private var state: UnderlinedTextFieldState = .normal {
        didSet(newValue) {
            updateUI(animated: true)
        }
    }

    private var placeholder: String?
    private var infoString: String?
    private var maxLength: Int?

    private var error: Bool = false
    private var mode: UnderlinedTextFieldMode = .plain
    private var nextInput: UIResponder?

    // MARK: - Internal Properties

    var onBeginEditing: ((UnderlinedTextField) -> Void)?
    var onDidChange: ((UnderlinedTextField) -> Void)?
    var onEndEditing: ((UnderlinedTextField) -> Void)?
    var onShouldReturn: ((UnderlinedTextField) -> Void)?
    var responder: UIResponder {
        return self.textfield
    }
    var validator: TextFieldValidation?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        configureTexts()
        updateUI(animated: false)
    }

    // MARK: - Internal Methods

    /// Allows you to install a placeholder, infoString in bottom label and maximum allowed string
    func configure(placeholder: String?, infoString: String?, maxLength: Int?) {
        self.placeholder = placeholder
        self.infoString = infoString
        self.maxLength = maxLength

        configureTexts()
    }

    /// Allows you to set autocorrection and keyboardType for textField
    func configure(correction: UITextAutocorrectionType, keyboardType: UIKeyboardType) {
        textfield.autocorrectionType = correction
        textfield.keyboardType = keyboardType
    }

    /// Allows you to set textContent type for textField
    func configureContentType(_ contentType: UITextContentType) {
        textfield.textContentType = contentType
    }

    /// Allows you to change current mode
    func setTextFieldMode(_ mode: UnderlinedTextFieldMode) {
        eyeButton.isHidden = mode != .password
        textfield.isSecureTextEntry = mode == .password
        setEyeButtonStyle(open: false)
        self.mode = mode
    }

    /// Sets next responder, which will be activated after 'Next' button in keyboard will be pressed
    func setNextResponder(_ nextResponder: UIResponder) {
        textfield.returnKeyType = .next
        nextInput = nextResponder
    }

    /// Allows you to set text in textField and update all UI elements
    func setText(_ text: String?) {
        textfield.text = text
        updateUI(animated: false)
    }

    /// Return current input string in textField
    func currentText() -> String? {
        return textfield.text
    }

    /// This method hide keyboard, when textField will be activated (e.g., for textField with date, which connectes with DatePicker)
    func hideKeyboard() {
        textfield.inputView = UIView()
    }

    /// Allows to set accessibilityIdentifier for textField
    func setTextFieldIdentifier(_ identifier: String) {
        textfield.accessibilityIdentifier = identifier
    }

    /// Allows to set view in 'error' state, optionally allows you to set the error message. If errorMessage is nil - label keeps the previous info message
    func setError(with errorMessage: String?, animated: Bool) {
        error = true
        if let message = errorMessage {
            bottomInfoLabel.text = message
        }
        updateUI(animated: animated)
    }

    /// Allows you to know current state: return true in case of current state is valid
    func isValidState() -> Bool {
        if !error {
            // case if user didn't activate this text field
            validate()
            updateUI(animated: true)
        }
        return !error
    }

    /// Clear text, reset error and update all UI elements - reset to default state
    func reset(animated: Bool) {
        textfield.text = ""
        error = false
        updateUI(animated: animated)
    }

    /// Disable paste action for textField
    func disablePasteAction() {
        textfield.pasteActionEnabled = false
    }

    /// Disable text field
    func disableTextField() {
        state = .disabled
        textfield.isEnabled = false
        textfield.textColor = Color.Text.gray
    }

    // MARK: - Actions

    @IBAction private func tapOnEye(_ sender: UIButton) {
        let isSecure = !textfield.isSecureTextEntry
        textfield.isSecureTextEntry = isSecure
        textfield.fixCursorPosition()
        setEyeButtonStyle(open: !isSecure)
    }

}

// MARK: - Private methods

private extension UnderlinedTextField {

    func configureUI() {
        topPlaceholderLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        bottomInfoLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        textfield.delegate = self
        textfield.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textfield.textColor = Color.Text.black
        textfield.tintColor = Color.Text.active
        textfield.returnKeyType = .done
        textfield.addTarget(self, action: #selector(textfieldEditingChange(_:)), for: .editingChanged)

        setEyeButtonStyle(open: false)
        eyeButton.isHidden = true
        eyeButton.tintColor = Color.Main.active
    }

    func configureTexts() {
        topPlaceholderLabel.text = placeholder
        bottomInfoLabel.text = infoString
        showTextFieldPlaceholder(show: true)
    }

    func setEyeButtonStyle(open: Bool) {
        let image = open ? UIImage(asset: Asset.eyeOn) : UIImage(asset: Asset.eyeOff)
        self.eyeButton.setImage(image, for: .normal)
    }

    func updateUI(animated: Bool) {
        var textIsEmpty = true
        if let text = textfield.text, !text.isEmpty {
            textIsEmpty = false
        }

        updateElementsColor(animated: animated)
        showTopPlaceholder(state == .active || !textIsEmpty, animated: animated)
        showTextFieldPlaceholder(show: state != .active)
        showBotomInfoLabel(error || (state == .active && self.infoString != nil), animated: animated)
        increaseSeparatorView(state == .active, animated: animated)
    }

    func validate() {
        if let currentValidator = validator {
            let (isValid, errorMessage) = currentValidator.validate(textForValidate())
            error = !isValid
            if let message = errorMessage, !isValid {
                bottomInfoLabel.text = message
            }
        }
    }

    /// Return text from textField. If formatter was defined, method will call formatter's method for get this text
    func textForValidate() -> String? {
        return textfield.text
    }

}

// MARK: - Animation

private extension UnderlinedTextField {

    func updateElementsColor(animated: Bool) {
        let currentTopPlaceholderColor = topPlaceholderColor()
        let currentSeparatorColor = separatorColor()
        let currentBottomInfoColor = bottomInfoColor()

        let animationDuration = animated ? Constant.animationDuration : 0.0

        transitionLabelColor(label: topPlaceholderLabel, color: currentTopPlaceholderColor, duration: animationDuration)
        transitionLabelColor(label: bottomInfoLabel, color: currentBottomInfoColor, duration: animationDuration)

        UIView.animate(withDuration: animationDuration) {
            self.separatorView.backgroundColor = currentSeparatorColor
        }
    }

    func transitionLabelColor(label: UILabel, color: UIColor, duration: TimeInterval = Constant.animationDuration) {
        UIView.transition(with: label, duration: duration, options: .transitionCrossDissolve, animations: {
            label.textColor = color
        })
    }

    func showTopPlaceholder(_ show: Bool, animated: Bool) {
        let actualOffset = show ? Constant.topPlaceholderVisibleOffset : Constant.topPlaceholderHiddenOffset
        let alpha: CGFloat = show ? 1.0 : 0.0
        placeholderTopOffsetConstraint.constant = actualOffset
        if animated {
            UIView.animate(withDuration: Constant.animationDuration) { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.topPlaceholderLabel.alpha = alpha
                self.view.layoutIfNeeded()
            }
        } else {
            self.topPlaceholderLabel.alpha = alpha
        }
    }

    func showTextFieldPlaceholder(show: Bool) {
        if let placeholder = self.placeholder, show {
            textfield.attributedPlaceholder = placeholder.with(attributes: [.foregroundColor(Color.Text.gray),
                                                                            .font(UIFont.systemFont(ofSize: 16, weight: .regular))])
        } else {
            textfield.placeholder = nil
        }
    }

    func showBotomInfoLabel(_ show: Bool, animated: Bool) {
        let alpha: CGFloat = show ? 1.0 : 0.0
        if animated {
            UIView.animate(withDuration: Constant.animationDuration) { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.bottomInfoLabel.alpha = alpha
            }
        } else {
            self.bottomInfoLabel.alpha = alpha
        }
    }

    func increaseSeparatorView(_ increase: Bool, animated: Bool) {
        separatorViewHeightConstraint.constant = increase ? Constant.bigSeparatorHeight : Constant.smallSeparatorHeight
        if animated {
            UIView.animate(withDuration: Constant.animationDuration) { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.view.layoutIfNeeded()
            }
        }
    }

}

// MARK: - Elements colors

private extension UnderlinedTextField {

    func topPlaceholderColor() -> UIColor {
        if error {
            return Color.Text.gray
        }

        switch state {
        case .normal:
            return Color.Text.gray
        case .active:
            return Color.Text.active
        case .disabled:
            return Color.Text.disabled
        }
    }

    func separatorColor() -> UIColor {
        if error {
            return Color.Main.red
        } else {
            return state == .active ? Color.Main.active : Color.Main.container
        }
    }

    func bottomInfoColor() -> UIColor {
        return error ? Color.Main.red : Color.Text.gray
    }

}

// MARK: - Formating TextField

private extension UnderlinedTextField {

    @objc
    func textfieldEditingChange(_ textField: UITextField) {
        if error {
            bottomInfoLabel.text = infoString
        }
        error = false
        updateUI(animated: true)
        onDidChange?(self)
    }

}

// MARK: - UITextFieldDelegate

extension UnderlinedTextField: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        state = .active
        onBeginEditing?(self)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        validate()
        state = .normal
        onEndEditing?(self)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let textRange = Range(range, in: text) else {
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
            textField.resignFirstResponder()
            onShouldReturn?(self)
            return true
        }
        return false
    }

}
