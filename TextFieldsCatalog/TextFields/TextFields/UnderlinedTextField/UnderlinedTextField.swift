//
//  UnderlinedTextField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 24/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import SurfUtils
import InputMask

/// Class for custom textField. Contains UITextFiled, top floating placeholder, underline line under textField and bottom label with some info.
/// Standart height equals 77. Colors, fonts and offsets do not change, they are protected inside (for now =))
final class UnderlinedTextField: DesignableView, ResetableField {

    // MARK: - Enums

    private enum UnderlinedTextFieldState {
        /// textField not in focus
        case normal
        /// state with active textField
        case active
        /// state for disabled textField
        case disabled
    }

    enum UnderlinedTextFieldMode {
        /// normal textField mode without any action buttons
        case plain
        /// mode for password textField
        case password
    }

    // MARK: - Constants

    private enum Constants {
        static let animationDuration: TimeInterval = 0.3
        static let smallSeparatorHeight: CGFloat = 1
        static let bigSeparatorHeight: CGFloat = 2

        static let topPlaceholderPosition: CGRect = CGRect(x: 16, y: 5, width: 288, height: 19)
        static let bottomPlaceholderPosition: CGRect = CGRect(x: 15, y: 23, width: 288, height: 19)
        static let bigPlaceholderFont: CGFloat = 16
        static let smallPlaceholderFont: CGFloat = 12

        static let defaultTextPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let increasedTextPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var textField: InnerTextField!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var hintLabel: UILabel!
    @IBOutlet private weak var actionButton: IconButton!

    // MARK: - NSLayoutConstraints

    @IBOutlet private weak var lineViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Private Properties

    private var state: UnderlinedTextFieldState = .normal {
        didSet {
            updateUI()
        }
    }

    private let placeholder: CATextLayer = CATextLayer()
    private var hintMessage: String?
    private var maxLength: Int?

    private var error: Bool = false
    private var mode: UnderlinedTextFieldMode = .plain
    private var nextInput: UIResponder?

    // MARK: - Properties

    var validator: TextFieldValidation?
    var maskFormatter: MaskTextFieldFormatter? {
        didSet {
            if maskFormatter != nil {
                textField.delegate = maskFormatter?.delegateForTextField()
                maskFormatter?.setListenerToFormatter(listener: self)
                textField.autocorrectionType = .no
            } else {
                textField.delegate = self
            }
        }
    }
    var hideOnReturn: Bool = true
    var validateWithFormatter: Bool = false

    var onBeginEditing: ((UnderlinedTextField) -> Void)?
    var onEndEditing: ((UnderlinedTextField) -> Void)?
    var onTextChanged: ((UnderlinedTextField) -> Void)?
    var onShouldReturn: ((UnderlinedTextField) -> Void)?
    var onActionButtonTap: ((UnderlinedTextField) -> Void)?
    var onValidateFail: ((UnderlinedTextField) -> Void)?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
        updateUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UIView

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
        updateUI()
    }

    // MARK: - Internal Methods

    /// Allows you to install a placeholder, infoString in bottom label and maximum allowed string
    func configure(placeholder: String?, maxLength: Int?) {
        self.placeholder.string = placeholder
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

    /// Allows you to set textContent type for textField
    func configureContentType(_ contentType: UITextContentType) {
        textField.textContentType = contentType
    }

    /// Allows you to change current mode
    func setTextFieldMode(_ mode: UnderlinedTextFieldMode) {
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

    /// This method hide keyboard, when textField will be activated (e.g., for textField with date, which connectes with DatePicker)
    func hideKeyboard() {
        textField.inputView = UIView()
    }

    /// Allows to set accessibilityIdentifier for textField
    func setTextFieldIdentifier(_ identifier: String) {
        textField.accessibilityIdentifier = identifier
    }

    /// Allows to set view in 'error' state, optionally allows you to set the error message. If errorMessage is nil - label keeps the previous info message
    func setError(with errorMessage: String?, animated: Bool) {
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

    /// Disable paste action for textField
    func disablePasteAction() {
        textField.pasteActionEnabled = false
    }

    /// Disable text field
    func disableTextField() {
        state = .disabled
        textField.isEnabled = false
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

    /// Sets next responder, which will be activated after 'Next' button in keyboard will be pressed
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

private extension UnderlinedTextField {

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
        placeholder.string = ""
        placeholder.font = UIFont.systemFont(ofSize: Constants.bigPlaceholderFont, weight: .regular).fontName as CFTypeRef?
        placeholder.fontSize = Constants.bigPlaceholderFont
        placeholder.foregroundColor = placeholderColor()
        placeholder.contentsScale = UIScreen.main.scale
        placeholder.frame = Constants.bottomPlaceholderPosition
        placeholder.truncationMode = CATextLayerTruncationMode.end
        self.layer.addSublayer(placeholder)
    }

    func configureTextField() {
        textField.delegate = maskFormatter?.delegateForTextField() ?? self
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.textColor = Color.Text.white
        textField.tintColor = Color.Text.active
        textField.returnKeyType = .done
        textField.textPadding = Constants.defaultTextPadding
        textField.addTarget(self, action: #selector(textfieldEditingChange(_:)), for: .editingChanged)
    }

    func configureHintLabel() {
        hintLabel.textColor = Color.Text.red
        hintLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        hintLabel.text = ""
        hintLabel.numberOfLines = 1
        hintLabel.alpha = 0
    }

    func configureActionButton() {
        actionButton.isHidden = true
    }

}

// MARK: - Actions

private extension UnderlinedTextField {

    @IBAction func tapOnActionButton(_ sender: UIButton) {
        onActionButtonTap?(self)
        textField.isSecureTextEntry.toggle()
        textField.fixCursorPosition()
        updatePasswordVisibilityButton()
    }

    @objc
    func textfieldEditingChange(_ textField: UITextField) {
        removeError()
        onTextChanged?(self)
    }

}

// MARK: - UITextFieldDelegate

extension UnderlinedTextField: UITextFieldDelegate {

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

extension UnderlinedTextField: MaskedTextFieldDelegateListener {

    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        maskFormatter?.textField(textField, didFillMandatoryCharacters: complete, didExtractValue: value)
        removeError()
        onTextChanged?(self)
    }

}

// MARK: - Private Methods

private extension UnderlinedTextField {

    func updateUI(animated: Bool = false) {
        updateHintLabelColor()
        updateHintLabelVisibility()
        updateLineViewColor()
        updateLineViewHeight()
        updateTextColor()
        updatePlaceholderColor()
        updatePlaceholderPosition()
        updatePlaceholderFont()
    }

    func updatePasswordVisibilityButton() {
        guard mode == .password else {
            return
        }
        let isSecure = textField.isSecureTextEntry
        let image = isSecure ? UIImage(asset: Asset.eyeOff) : UIImage(asset: Asset.eyeOn)
        actionButton.setImageForAllState(image)
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

    func shouldShowHint() -> Bool {
        return (state == .active && hintMessage != nil) || error
    }

    /// Return true, if floating placeholder should placed on top in current state, false in other case
    func shouldMovePlaceholderOnTop() -> Bool {
        return state == .active || !textIsEmpty()
    }

    /// Return true, if current input string is empty
    func textIsEmpty() -> Bool {
        guard let text = textField.text else {
            return true
        }
        return text.isEmpty
    }

}

// MARK: - Updating

private extension UnderlinedTextField {

    func updateHintLabelColor() {
        hintLabel.textColor = hintTextColor()
    }

    func updateHintLabelVisibility() {
        let alpha: CGFloat = shouldShowHint() ? 1 : 0
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.hintLabel.alpha = alpha
        }
    }

    func updateLineViewColor() {
        let color = lineColor()
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.lineView.backgroundColor = color
        }
    }

    func updateLineViewHeight() {
        let height = state == .active ? Constants.bigSeparatorHeight : Constants.smallSeparatorHeight
        lineViewHeightConstraint.constant = height
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    func updateTextColor() {
        textField.textColor = textColor()
    }

    func updatePlaceholderColor() {
        let startColor: CGColor = currentPlaceholderColor()
        let endColor: CGColor = placeholderColor()
        placeholder.foregroundColor = endColor

        let colorAnimation = CABasicAnimation(keyPath: "foregroundColor")
        colorAnimation.fromValue = startColor
        colorAnimation.toValue = endColor
        colorAnimation.duration = Constants.animationDuration
        colorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        placeholder.add(colorAnimation, forKey: nil)
    }

    func updatePlaceholderPosition() {
        let startPosition: CGRect = currentPlaceholderPosition()
        let endPosition: CGRect = placeholderPosition()
        placeholder.frame = endPosition

        let frameAnimation = CABasicAnimation(keyPath: "frame")
        frameAnimation.fromValue = startPosition
        frameAnimation.toValue = endPosition
        frameAnimation.duration = Constants.animationDuration
        frameAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        placeholder.add(frameAnimation, forKey: nil)
    }

    func updatePlaceholderFont() {
        let startFontSize: CGFloat = currentPlaceholderFontSize()
        let endFontSize: CGFloat = placeholderFontSize()
        placeholder.fontSize = endFontSize

        let fontSizeAnimation = CABasicAnimation(keyPath: "fontSize")
        fontSizeAnimation.fromValue = startFontSize
        fontSizeAnimation.toValue = endFontSize
        fontSizeAnimation.duration = Constants.animationDuration
        fontSizeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        placeholder.add(fontSizeAnimation, forKey: nil)
    }

}

// MARK: - Elements colors

private extension UnderlinedTextField {

    func textColor() -> UIColor {
        return Color.Text.white
    }

    func currentPlaceholderColor() -> CGColor {
        return placeholder.foregroundColor ?? Color.Text.white.cgColor
    }

    func placeholderColor() -> CGColor {
        switch state {
        case .active:
            return Color.Text.active.cgColor
        case .normal:
            return shouldMovePlaceholderOnTop() ? Color.Text.active.cgColor : Color.Text.white.cgColor
        case .disabled:
            return Color.Text.gray.cgColor
        }
    }

    func currentPlaceholderPosition() -> CGRect {
        return placeholder.frame
    }

    func placeholderPosition() -> CGRect {
        return shouldMovePlaceholderOnTop() ? Constants.topPlaceholderPosition : Constants.bottomPlaceholderPosition
    }

    func currentPlaceholderFontSize() -> CGFloat {
        return placeholder.fontSize
    }

    func placeholderFontSize() -> CGFloat {
        return shouldMovePlaceholderOnTop() ? Constants.smallPlaceholderFont : Constants.bigPlaceholderFont
    }

    func lineColor() -> UIColor {
        if error {
            return Color.Main.red
        } else {
            return state == .active ? Color.Main.active : Color.Main.container
        }
    }

    func hintTextColor() -> UIColor {
        return error ? Color.Main.red : Color.Text.gray
    }

}
