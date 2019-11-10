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

    private var state: FieldState = .normal {
        didSet {
            updateUI()
        }
    }
    private var maxLength: Int?
    private var hintMessage: String?

    private var error: Bool = false
    private var mode: TextFieldMode = .plain
    private var nextInput: UIResponder?
    private var previousInput: UIResponder?
    private var heightConstraint: NSLayoutConstraint?
    private var lastViewHeight: CGFloat = 0
    private var isChangesWereMade = false

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
    public var validationPolicy: ValidationPolicy = .always
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
    override open var inputView: UIView? {
        get {
            return textField.inputView
        }
        set {
            textField.inputView = newValue
        }
    }

    public var onBeginEditing: ((BorderedTextField) -> Void)?
    public var onEndEditing: ((BorderedTextField) -> Void)?
    public var onTextChanged: ((BorderedTextField) -> Void)?
    public var onShouldReturn: ((BorderedTextField) -> Void)?
    public var onActionButtonTap: ((BorderedTextField) -> Void)?
    public var onValidateFail: ((BorderedTextField) -> Void)?
    public var onHeightChanged: ((CGFloat) -> Void)?
    public var onDateChanged: ((Date) -> Void)?

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

    override open  func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
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

    /// Allows you to set autocapitalization type for textField
    public func configure(autocapitalizationType: UITextAutocapitalizationType) {
        textField.autocapitalizationType = autocapitalizationType
    }

    /// Allows you to change current mode
    public func setTextFieldMode(_ mode: TextFieldMode) {
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
            updatePasswordButtonIcon()
            updatePasswordButtonVisibility()
        case .custom(let actionButtonConfig):
            actionButton.isHidden = false
            actionButton.alpha = 1
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

    /// This method hide keyboard, when textField will be activated (e.g., for textField with date, which connectes with DatePicker)
    public func hideKeyboard() {
        textField.inputView = UIView()
    }

    /// Allows to set accessibilityIdentifier for textField and its internal elements
    public func setTextFieldIdentifier(_ identifier: String) {
        view.accessibilityIdentifier = identifier
        textField.accessibilityIdentifier = identifier + AccessibilityIdentifiers.field
        actionButton.accessibilityIdentifier = identifier + AccessibilityIdentifiers.button
        hintLabel.accessibilityIdentifier = identifier + AccessibilityIdentifiers.hint
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
        setupHintText(hintMessage ?? "")
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
        /// fix for bug, when text field not changing his textColor on iphone 6+
        textField.text = currentText()
    }

    /// Enable text field
    public func enableTextField() {
        state = .normal
        textField.isEnabled = true
        updateUI()
        /// fix for bug, when text field not changing his textColor on iphone 6+
        textField.text = currentText()
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

    /// Sets previous responder, which will be activated after 'Back' button in keyboard toolbar will be pressed.
    /// 'Back' button appears only into the topView in custom input views, which you can find in this library.
    public func setPreviousResponder(_ nextResponder: UIResponder) {
        previousInput = nextResponder
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
        updatePasswordButtonIcon()
    }

    @objc
    func textFieldEditingChange(_ textField: UITextField) {
        removeError()
        updatePasswordButtonVisibility()
        performOnTextChangedCall()
    }

}

// MARK: - UITextFieldDelegate

extension BorderedTextField: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        state = .active
        onBeginEditing?(self)
    }

    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        switch validationPolicy {
        case .always:
            validate()
        case .notEmptyText:
            if !textIsEmpty() {
                validate()
            }
        case .afterChanges:
            if isChangesWereMade {
                validate()
            }
        case .never:
            break
        }
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
        updatePasswordButtonVisibility()
        performOnTextChangedCall()
    }

}

// MARK: - GuidedTextField

extension BorderedTextField: GuidedTextField {

    public var havePreviousInput: Bool {
        return previousInput != nil
    }

    public var haveNextInput: Bool {
        return nextInput != nil
    }

    public func processReturnAction() {
        textField.resignFirstResponder()
    }

    public func switchToPreviousInput() {
        previousInput?.becomeFirstResponder()
    }

    public func switchToNextInput() {
        nextInput?.becomeFirstResponder()
    }

}

// MARK: - DateTextField

extension BorderedTextField: DateTextField {

    public func processDateChange(_ date: Date, text: String) {
        setText(text)
        onDateChanged?(date)
    }

}

// MARK: - PickerTextField

extension BorderedTextField: PickerTextField {

    public func processValueChange(_ value: String) {
        setText(value)
        performOnTextChangedCall()
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
        updatePasswordButtonVisibility()
    }

    func updatePasswordButtonIcon() {
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
        isChangesWereMade = true
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

    /// Return true, if current input string is empty
    func textIsEmpty() -> Bool {
        return textField.text?.isEmpty ?? true
    }

    func setupHintText(_ hintText: String) {
        hintLabel.attributedText = hintText.with(lineHeight: configuration.hint.lineHeight,
                                                 font: configuration.hint.font,
                                                 color: hintLabel.textColor)
    }

    func performOnTextChangedCall() {
        if !isChangesWereMade {
            isChangesWereMade = !textIsEmpty()
        }
        onTextChanged?(self)
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

    func updatePasswordButtonVisibility() {
        guard case .password(let behavior) = mode else {
            return
        }
        guard behavior == .visibleOnNotEmptyText else {
            actionButton.alpha = 1
            return
        }
        let textIsEmpty = textField.text?.isEmpty ?? true
        let alpha: CGFloat = textIsEmpty ? 0 : 1
        guard alpha != actionButton.alpha else {
            return
        }
        let duration = alpha == 0 ? 0 : Constants.animationDuration
        UIView.animate(withDuration: duration) { [weak self] in
            self?.actionButton.alpha = alpha
        }
    }

}

// MARK: - Computed Colors

private extension BorderedTextField {

    func hintLabelHeight() -> CGFloat {
        let hintIsVisible = shouldShowHint()
        if let hint = hintLabel.text, !hint.isEmpty, hintIsVisible {
            return hint.height(forWidth: hintLabel.bounds.size.width, font: configuration.hint.font, lineHeight: configuration.hint.lineHeight)
        }
        return 0
    }

    func placeholderTextColor() -> UIColor {
        return configuration.placeholder.colors.suitableColor(fieldState: state, isActiveError: error)
    }

    func hintTextColor() -> UIColor {
        return configuration.hint.colors.suitableColor(fieldState: state, isActiveError: error)
    }

    func textColor() -> UIColor {
        return configuration.textField.colors.suitableColor(fieldState: state, isActiveError: error)
    }

    func currentTextFieldBorderColor() -> CGColor {
        return textField.layer.borderColor ?? configuration.textFieldBorder.colors.normal.cgColor
    }

    func textFieldBorderColor() -> CGColor {
        return configuration.textFieldBorder.colors.suitableColor(fieldState: state, isActiveError: error).cgColor
    }

}
