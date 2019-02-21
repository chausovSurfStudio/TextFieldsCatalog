//
//  BorderedTextField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import InputMask

/// Class for custom textField, where text field have a highlighted border. Default height equals to 130.
open class BorderedTextField: InnerDesignableView, ResetableField {

    // MARK: - Enums

    private enum BorderedTextFieldState {
        /// textField not in focus
        case normal
        /// state for active textField
        case active
        /// state for disabled textField
        case disabled
    }

    public enum BorderedTextFieldMode {
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

    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var textField: InnerTextField!
    @IBOutlet private weak var actionButton: IconButton!
    @IBOutlet private weak var hintLabel: UILabel!

    // MARK: - Private Properties

    private var state: BorderedTextFieldState = .normal {
        didSet {
            updateUI()
        }
    }
    private var maxLength: Int?
    private var hintMessage: String?

    private var error: Bool = false
    private var mode: BorderedTextFieldMode = .plain
    private var nextInput: UIResponder?
    private var heightConstraint: NSLayoutConstraint?
    private var lastViewHeight: CGFloat = 0

    // MARK: - Properties

    public var configuration = BorderedTextFieldConfiguration() {
        didSet {
            configureAppearance()
            updateUI()
        }
    }
    public var validator: TextFieldValidation?
    public var maskFormatter: MaskTextFieldFormatter? {
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
    public var hideOnReturn: Bool = true
    public var validateWithFormatter: Bool = false
    public var heightLayoutPolicy: HeightLayoutPolicy = .fixed {
        didSet {
            switch heightLayoutPolicy {
            case .fixed:
                hintLabel.numberOfLines = 1
            case .flexible(_, _):
                hintLabel.numberOfLines = 0
            }
        }
    }
    public var responder: UIResponder {
        return self.textField
    }

    public var onBeginEditing: ((BorderedTextField) -> Void)?
    public var onEndEditing: ((BorderedTextField) -> Void)?
    public var onTextChanged: ((BorderedTextField) -> Void)?
    public var onShouldReturn: ((BorderedTextField) -> Void)?
    public var onActionButtonTap: ((BorderedTextField) -> Void)?
    public var onValidateFail: ((BorderedTextField) -> Void)?
    public var onHeightChanged: ((CGFloat) -> Void)?

    // MARK: - Initialization

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
        updateUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UIView

    override open func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
        updateUI()
    }

    // MARK: - Public Methods

    /// Method for configure text field with placeholder and max length for input string
    public func configure(placeholder: String?, maxLength: Int?) {
        self.placeholderLabel.text = placeholder
        self.maxLength = maxLength
    }

    /// Allows you to set constraint on view height, this constraint will be changed if view height is changed later
    public func configure(heightConstraint: NSLayoutConstraint) {
        self.heightConstraint = heightConstraint
    }

    /// Allows you to set autocorrection and keyboardType for textField
    public func configure(correction: UITextAutocorrectionType?, keyboardType: UIKeyboardType?) {
        if let correction = correction {
            textField.autocorrectionType = correction
        }
        if let keyboardType = keyboardType {
            textField.keyboardType = keyboardType
        }
    }

    /// Allows you to change current mode
    public func setTextFieldMode(_ mode: BorderedTextFieldMode) {
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
    public func setText(_ text: String?) {
        if let formatter = maskFormatter {
            formatter.format(string: text, field: textField)
        } else {
            textField.text = text
        }
        validate()
        updateUI()
    }

    /// Return current input string in textField
    public func currentText() -> String? {
        return textField.text
    }

    /// Allows to set view in 'error' state, optionally allows you to set the error message. If errorMessage is nil - label keeps the previous hint message
    public func setError(with errorMessage: String?) {
        error = true
        if let message = errorMessage {
            setupHintText(message)
        }
        updateUI()
    }

    /// Allows you to know current state: return true in case of current state is valid
    @discardableResult
    public func isValidState(forceValidate: Bool = false) -> Bool {
        if !error || forceValidate {
            // case if user didn't activate this text field (or you want force validate it)
            validate()
            updateUI()
        }
        return !error
    }

    /// Clear text, reset error and update all UI elements - reset to default state
    public func reset() {
        textField.text = ""
        error = false
        updateUI()
    }

    /// Reset only error state and update all UI elements
    public func resetErrorState() {
        error = false
        updateUI()
    }

    /// Allows you to disable paste action for textField
    public func disablePasteAction() {
        textField.pasteActionEnabled = false
    }

    /// Disable text field
    public func disableTextField() {
        state = .disabled
        textField.isEnabled = false
        updateUI()
    }

    /// Enable text field
    public func enableTextField() {
        state = .normal
        textField.isEnabled = true
        updateUI()
    }

    /// Return true if current state allows you to interact with this field
    public func isEnabled() -> Bool {
        return state != .disabled
    }

    /// Allows you to set some string as hint message
    public func setHint(_ hint: String) {
        guard !hint.isEmpty else {
            return
        }
        hintMessage = hint
        setupHintText(hint)
    }

    /// Return true, if field is current firstResponder
    public func isCurrentFirstResponder() -> Bool {
        return textField.isFirstResponder
    }

    /// Allows you to set next textField and go to him on return keyboard button tap
    public func setNextResponder(_ nextResponder: UIResponder) {
        textField.returnKeyType = .next
        nextInput = nextResponder
    }

    /// Makes textField is current first responder
    public func makeFirstResponder() {
        _ = textField.becomeFirstResponder()
    }

    /// Allows you to manage keyboard returnKeyType
    public func setReturnKeyType(_ type: UIReturnKeyType) {
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
        view.backgroundColor = configuration.background.color
    }

    func configurePlaceholder() {
        placeholderLabel.textColor = placeholderTextColor()
        placeholderLabel.font = configuration.placeholder.font
        placeholderLabel.text = ""
    }

    func configureTextField() {
        textField.delegate = maskFormatter?.delegateForTextField() ?? self
        textField.font = configuration.textField.font
        textField.textColor = textColor()
        textField.tintColor = configuration.textField.tintColor

        textField.layer.borderColor = textFieldBorderColor()
        textField.layer.borderWidth = configuration.textFieldBorder.width
        textField.layer.cornerRadius = configuration.textFieldBorder.cornerRadius
        textField.backgroundColor = configuration.background.color
        textField.textPadding = configuration.textField.defaultPadding

        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(textFieldEditingChange(_:)), for: .editingChanged)
    }

    func configureHintLabel() {
        hintLabel.textColor = hintTextColor()
        hintLabel.font = configuration.hint.font
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
        guard case .password = mode else {
            return
        }
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

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        state = .active
        onBeginEditing?(self)
    }

    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        validate()
        state = .normal
        onEndEditing?(self)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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

    public func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
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
        updateViewHeight()
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

    func shouldShowHint() -> Bool {
        return (state == .active && hintMessage != nil) || error
    }

    func validate() {
        if let formatter = maskFormatter, validateWithFormatter {
            let (isValid, errorMessage) = formatter.validate()
            error = !isValid
            if let message = errorMessage, !isValid {
                setupHintText(message)
            }
        } else if let currentValidator = validator {
            let (isValid, errorMessage) = currentValidator.validate(textField.text)
            error = !isValid
            if let message = errorMessage, !isValid {
                setupHintText(message)
            }
        }
        if error {
            onValidateFail?(self)
        }
    }

    func removeError() {
        if error {
            setupHintText(hintMessage ?? "")
            error = false
            updateUI()
        }
    }

    func setupHintText(_ hintText: String) {
        hintLabel.attributedText = hintText.with(lineHeight: configuration.hint.lineHeight,
                                                 font: configuration.hint.font,
                                                 color: hintLabel.textColor)
    }

}

// MARK: - Updating

private extension BorderedTextField {

    func updateHintLabelColor() {
        hintLabel.textColor = hintTextColor()
    }

    func updateHintLabelVisibility() {
        let alpha: CGFloat = shouldShowHint() ? 1 : 0
        var duration: TimeInterval = Constants.animationDuration
        switch heightLayoutPolicy {
        case .fixed:
            // update always with animation
            break
        case .flexible(_, _):
            // update with animation on hint appear
            duration = shouldShowHint() ? Constants.animationDuration : 0
        }
        UIView.animate(withDuration: duration) { [weak self] in
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

    func updateViewHeight() {
        switch heightLayoutPolicy {
        case .fixed:
            break
        case .flexible(let minHeight, let bottomSpace):
            let hintHeight: CGFloat = hintLabelHeight()
            let actualViewHeight = hintLabel.frame.origin.y + hintHeight + bottomSpace
            let viewHeight = max(minHeight, actualViewHeight)
            guard lastViewHeight != viewHeight else {
                return
            }
            lastViewHeight = viewHeight
            heightConstraint?.constant = viewHeight
            onHeightChanged?(viewHeight)
        }
    }

}

// MARK: - Computed Colors

private extension BorderedTextField {

    func hintLabelHeight() -> CGFloat {
        let hintIsVisible = shouldShowHint()
        if let hint = hintLabel.text, hintIsVisible {
            return hint.height(forWidth: hintLabel.bounds.size.width, font: configuration.hint.font, lineHeight: configuration.hint.lineHeight)
        }
        return 0
    }

    func placeholderTextColor() -> UIColor {
        return suitableColor(from: configuration.placeholder.colors)
    }

    func hintTextColor() -> UIColor {
        return suitableColor(from: configuration.hint.colors)
    }

    func textColor() -> UIColor {
        return suitableColor(from: configuration.textField.colors)
    }

    func currentTextFieldBorderColor() -> CGColor {
        return textField.layer.borderColor ?? configuration.textFieldBorder.colors.normal.cgColor
    }

    func textFieldBorderColor() -> CGColor {
        return suitableColor(from: configuration.textFieldBorder.colors).cgColor
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
