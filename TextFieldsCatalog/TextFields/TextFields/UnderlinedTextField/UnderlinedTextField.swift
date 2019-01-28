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
class UnderlinedTextField: DesignableView, ResetableField {

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
        /// mode for textField with custom action button
        case custom(ActionButtonConfiguration)
    }

    // MARK: - Constants

    private enum Constants {
        static let animationDuration: TimeInterval = 0.3
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

    var configuration = UnderlinedTextFieldConfiguration() {
        didSet {
            configureAppearance()
            updateUI()
        }
    }
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
            textField.textPadding = configuration.textField.defaultPadding
        case .password:
            actionButton.isHidden = false
            textField.isSecureTextEntry = true
            textField.textPadding = configuration.textField.increasedPadding
            updatePasswordVisibilityButton()
        case .custom(let actionButtonConfig):
            actionButton.isHidden = false
            textField.isSecureTextEntry = false
            textField.textPadding = configuration.textField.increasedPadding
            actionButton.setImageForAllState(actionButtonConfig.image,
                                             normalColor: actionButtonConfig.normalColor,
                                             pressedColor: actionButtonConfig.pressedColor)
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
        configureLineView()
    }

    func configureBackground() {
        view.backgroundColor = configuration.background.color
    }

    func configurePlaceholder() {
        placeholder.removeFromSuperlayer()
        placeholder.string = ""
        placeholder.font = configuration.placeholder.font.fontName as CFTypeRef?
        placeholder.fontSize = configuration.placeholder.bigFontSize
        placeholder.foregroundColor = placeholderColor()
        placeholder.contentsScale = UIScreen.main.scale
        placeholder.frame = placeholderPosition()
        placeholder.truncationMode = CATextLayerTruncationMode.end
        self.layer.addSublayer(placeholder)
    }

    func configureTextField() {
        textField.delegate = maskFormatter?.delegateForTextField() ?? self
        textField.font = configuration.textField.font
        textField.textColor = configuration.textField.colors.normal
        textField.tintColor = configuration.textField.tintColor
        textField.returnKeyType = .done
        textField.textPadding = configuration.textField.defaultPadding
        textField.addTarget(self, action: #selector(textfieldEditingChange(_:)), for: .editingChanged)
    }

    func configureHintLabel() {
        hintLabel.textColor = configuration.hint.colors.normal
        hintLabel.font = configuration.hint.font
        hintLabel.text = ""
        hintLabel.numberOfLines = 1
        hintLabel.alpha = 0
    }

    func configureActionButton() {
        actionButton.isHidden = true
    }

    func configureLineView() {
        lineView.layer.cornerRadius = configuration.line.cornerRadius
        lineView.layer.masksToBounds = true
    }

}

// MARK: - Actions

private extension UnderlinedTextField {

    @IBAction func tapOnActionButton(_ sender: UIButton) {
        onActionButtonTap?(self)
        guard case .password = mode else {
            return
        }
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
        guard case .password = mode else {
            return
        }
        let isSecure = textField.isSecureTextEntry
        let image = isSecure ? configuration.passwordMode.secureModeOffImage : configuration.passwordMode.secureModeOnImage
        actionButton.setImageForAllState(image,
                                         normalColor: configuration.passwordMode.normalColor,
                                         pressedColor: configuration.passwordMode.pressedColor)
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
        let height = state == .active ? configuration.line.bigHeight : configuration.line.smallHeight
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
        return suitableColor(from: configuration.textField.colors)
    }

    func currentPlaceholderColor() -> CGColor {
        return placeholder.foregroundColor ?? configuration.placeholder.bottomColors.normal.cgColor
    }

    func placeholderColor() -> CGColor {
        let colorsConfiguration = shouldMovePlaceholderOnTop() ? configuration.placeholder.topColors : configuration.placeholder.bottomColors
        return suitableColor(from: colorsConfiguration).cgColor
    }

    func currentPlaceholderPosition() -> CGRect {
        return placeholder.frame
    }

    func placeholderPosition() -> CGRect {
        let targetInsets = shouldMovePlaceholderOnTop() ? configuration.placeholder.topInsets : configuration.placeholder.bottomInsets
        var placeholderFrame = view.bounds.inset(by: targetInsets)
        placeholderFrame.size.height = configuration.placeholder.height
        return placeholderFrame
    }

    func currentPlaceholderFontSize() -> CGFloat {
        return placeholder.fontSize
    }

    func placeholderFontSize() -> CGFloat {
        return shouldMovePlaceholderOnTop() ? configuration.placeholder.smallFontSize : configuration.placeholder.bigFontSize
    }

    func lineColor() -> UIColor {
        return suitableColor(from: configuration.line.colors)
    }

    func hintTextColor() -> UIColor {
        return suitableColor(from: configuration.hint.colors)
    }

    func suitableColor(from colorConfiguration: ColorConfiguration) -> UIColor {
        guard !error else {
            return colorConfiguration.error
        }
        switch state {
        case .active:
            return colorConfiguration.active
        case .normal:
            return colorConfiguration.normal
        case .disabled:
            return colorConfiguration.disabled
        }
    }

}
