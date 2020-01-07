//
//  UnderlinedTextField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 24/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import InputMask

/// Class for custom textField. Contains UITextFiled, top floating placeholder, underline line under textField and bottom label with some info.
/// Standart height equals 77.
open class UnderlinedTextField: InnerDesignableView, ResetableField {

    // MARK: - Constants

    private enum Constants {
        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var textField: InnerTextField!
    @IBOutlet private weak var hintLabel: UILabel!
    @IBOutlet private weak var actionButton: IconButton!

    // MARK: - Private Properties

    private let lineView = UIView()
    private var state: FieldState = .normal {
        didSet {
            updateUI()
            perfromOnContainerStateChangedCall()
        }
    }

    private let placeholder: CATextLayer = CATextLayer()
    private var hintMessage: String?
    private var maxLength: Int?

    private var error: Bool = false {
        didSet {
            perfromOnContainerStateChangedCall()
        }
    }
    private var mode: TextFieldMode = .plain
    private var nextInput: UIResponder?
    private var previousInput: UIResponder?
    private var heightConstraint: NSLayoutConstraint?
    private var lastViewHeight: CGFloat = 0
    /// This flag set to `true` after first text changes and first call of validate() method
    private var isInteractionOccured = false

    // MARK: - Properties

    public var configuration = UnderlinedTextFieldConfiguration() {
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
    public var isNativePlaceholder = false
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

    public var onBeginEditing: ((UnderlinedTextField) -> Void)?
    public var onEndEditing: ((UnderlinedTextField) -> Void)?
    public var onTextChanged: ((UnderlinedTextField) -> Void)?
    public var onShouldReturn: ((UnderlinedTextField) -> Void)?
    public var onActionButtonTap: ((UnderlinedTextField) -> Void)?
    public var onValidateFail: ((UnderlinedTextField) -> Void)?
    public var onHeightChanged: ((CGFloat) -> Void)?
    public var onDateChanged: ((Date) -> Void)?
    public var onContainerStateChanged: ((FieldContainerState) -> Void)?

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

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateUI()
        perfromOnContainerStateChangedCall()
        setTextFieldMode(mode)
    }

    // MARK: - Public Methods

    /// Allows you to install a placeholder, infoString in bottom label and maximum allowed string
    public func configure(placeholder: String?, maxLength: Int?) {
        self.placeholder.string = placeholder
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

    /// Allows you to set textContent type for textField
    public func configureContentType(_ contentType: UITextContentType) {
        textField.textContentType = contentType
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

    /// Allows to set view in 'error' state, optionally allows you to set the error message. If errorMessage is nil - label keeps the previous info message
    public func setError(with errorMessage: String?, animated: Bool) {
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

    /// Disable paste action for textField
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

    /// Sets next responder, which will be activated after 'Next' button in keyboard will be pressed
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
        placeholder.font = configuration.placeholder.font
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
        let superview = configuration.line.superview ?? view
        if lineView.superview == nil || lineView.superview != superview {
            lineView.removeFromSuperview()
            superview.addSubview(lineView)
        }
        lineView.frame = linePosition()
        lineView.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth]
        lineView.layer.cornerRadius = configuration.line.cornerRadius
        lineView.layer.masksToBounds = true
        lineView.backgroundColor = configuration.line.colors.normal
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
        updatePasswordButtonIcon()
    }

    @objc
    func textfieldEditingChange(_ textField: UITextField) {
        removeError()
        updatePasswordButtonVisibility()
        updatePlaceholderVisibility()
        performOnTextChangedCall()
    }

}

// MARK: - UITextFieldDelegate

extension UnderlinedTextField: UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        state = .active
        onBeginEditing?(self)
    }

    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        validateWithPolicy()
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

extension UnderlinedTextField: MaskedTextFieldDelegateListener {

    public func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        maskFormatter?.textField(textField, didFillMandatoryCharacters: complete, didExtractValue: value)
        removeError()
        updatePasswordButtonVisibility()
        updatePlaceholderVisibility()
        performOnTextChangedCall()
    }

}

// MARK: - GuidedTextField

extension UnderlinedTextField: GuidedTextField {

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

extension UnderlinedTextField: DateTextField {

    public func processDateChange(_ date: Date, text: String) {
        setText(text)
        onDateChanged?(date)
    }

}

// MARK: - PickerTextField

extension UnderlinedTextField: PickerTextField {

    public func processValueChange(_ value: String) {
        setText(value)
        performOnTextChangedCall()
    }

}

// MARK: - Private Methods

private extension UnderlinedTextField {

    func updateUI(animated: Bool = false) {
        updateHintLabelColor()
        updateHintLabelVisibility()

        updatePlaceholderColor()
        updatePlaceholderPosition()
        updatePlaceholderFont()
        updatePlaceholderVisibility()

        updateTextColor()
        updateViewHeight()

        updateLineViewColor()
        updateLineViewHeight()

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

    func validateWithPolicy() {
        switch validationPolicy {
        case .always:
            validate()
        case .notEmptyText:
            if !textIsEmpty() {
                validate()
            }
        case .afterChanges:
            if isInteractionOccured {
                validate()
            }
        case .never:
            break
        }
    }

    func validate() {
        isInteractionOccured = true
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

    func shouldShowHint() -> Bool {
        return (state == .active && hintMessage != nil) || error
    }

    /// Return true, if floating placeholder should placed on top in current state, false in other case
    func shouldMovePlaceholderOnTop() -> Bool {
        return state == .active || !textIsEmpty()
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
        if !isInteractionOccured {
            isInteractionOccured = !textIsEmpty()
        }
        onTextChanged?(self)
    }

    func perfromOnContainerStateChangedCall() {
        guard !error else {
            onContainerStateChanged?(.error)
            return
        }
        onContainerStateChanged?(state.containerState)
    }

}

// MARK: - Updating

private extension UnderlinedTextField {

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

    func updateLineViewColor() {
        let color = lineColor()
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.lineView.backgroundColor = color
        }
    }

    func updateLineViewHeight() {
        let height = lineHeight()
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.lineView.frame.size.height = height
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
        guard !isNativePlaceholder else {
            return
        }
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

    func updatePlaceholderVisibility() {
        placeholder.isHidden = isNativePlaceholder && !textIsEmpty()
    }

}

// MARK: - Computed values

private extension UnderlinedTextField {

    func hintLabelHeight() -> CGFloat {
        let hintIsVisible = shouldShowHint()
        if let hint = hintLabel.text, !hint.isEmpty, hintIsVisible {
            return hint.height(forWidth: hintLabel.bounds.size.width, font: configuration.hint.font, lineHeight: configuration.hint.lineHeight)
        }
        return 0
    }

    func textColor() -> UIColor {
        return configuration.textField.colors.suitableColor(fieldState: state, isActiveError: error)
    }

    func currentPlaceholderColor() -> CGColor {
        return placeholder.foregroundColor ?? configuration.placeholder.bottomColors.normal.cgColor
    }

    func placeholderColor() -> CGColor {
        let colorsConfiguration = shouldMovePlaceholderOnTop() ? configuration.placeholder.topColors : configuration.placeholder.bottomColors
        return colorsConfiguration.suitableColor(fieldState: state, isActiveError: error).cgColor
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
        return configuration.line.colors.suitableColor(fieldState: state, isActiveError: error)
    }

    func linePosition() -> CGRect {
        let height = lineHeight()
        let superview = configuration.line.superview ?? view
        var lineFrame = superview.bounds.inset(by: configuration.line.insets)
        lineFrame.size.height = height
        return lineFrame
    }

    func lineHeight() -> CGFloat {
        return state == .active ? configuration.line.increasedHeight : configuration.line.defaultHeight
    }

    func hintTextColor() -> UIColor {
        return configuration.hint.colors.suitableColor(fieldState: state, isActiveError: error)
    }

}
