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
open class UnderlinedTextField: InnerDesignableView, ResetableField, RespondableField {

    // MARK: - IBOutlets

    @IBOutlet private weak var textField: InnerTextField!
    @IBOutlet private weak var hintLabel: UILabel!
    @IBOutlet private weak var actionButton: IconButton!

    // MARK: - Private Properties

    private var state: FieldState = .normal {
        didSet {
            updateUI()
            perfromOnContainerStateChangedCall()
        }
    }
    private var containerState: FieldContainerState {
        guard !error else {
            return .error
        }
        return state.containerState
    }
    private var error: Bool = false {
        didSet {
            perfromOnContainerStateChangedCall()
        }
    }

    private var heightConstraint: NSLayoutConstraint?
    private var lastViewHeight: CGFloat = 0
    /// This flag set to `true` after first text changes and first call of validate() method
    private var isInteractionOccured = false
    /// This flag is set to true and never changes again
    /// after the user has changed the text in the field for the first time
    private var isTextChanged = false

    // MARK: - Services

    private var fieldService: FieldService?
    private var lineService: LineService?
    private var hintService: HintService?
    private var placeholderServices: [AbstractPlaceholderService] = [FloatingPlaceholderService(configuration: .defaultForTextField)]

    // MARK: - Public Properties

    public var field: InnerTextField {
        return textField
    }
    public var text: String {
        get {
            return textField.text ?? ""
        }
        set {
            setup(text: newValue)
        }
    }
    /// Property allows you to install placeholder into the first placeholder service.
    /// If you will use more than one service - install placeholder to it manually.
    /// Getter returns only nil value.
    public var placeholder: String? {
        get {
            return nil
        }
        set {
            placeholderServices.first?.setup(placeholder: newValue)
        }
    }
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
    public var toolbar: ToolBarInterface? {
        didSet {
            textField.inputAccessoryView = toolbar
            toolbar?.guidedField = self
            toolbar?.updateNavigationButtons()
        }
    }
    public var maxLength: Int?
    public var hideOnReturn: Bool = true
    public var validateWithFormatter: Bool = false
    public var validationPolicy: ValidationPolicy = .always
    public var heightLayoutPolicy: HeightLayoutPolicy = .elastic(minHeight: 77, bottomSpace: 5, ignoreEmptyHint: false) {
        didSet {
            hintService?.setup(heightLayoutPolicy: heightLayoutPolicy)
            switch heightLayoutPolicy {
            case .fixed:
                hintLabel.numberOfLines = 1
            case .flexible, .elastic:
                hintLabel.numberOfLines = 0
            }
        }
    }
    public var mode: TextFieldMode = .plain {
        didSet {
            setup(textFieldMode: mode)
        }
    }
    public var isEnabled: Bool {
        get {
            return state != .disabled
        }
        set {
            if newValue {
                enableTextField()
            } else {
                disableTextField()
            }
        }
    }
    public var isValid: Bool {
        return !error
    }

    // MARK: - Events

    public var onBeginEditing: ((UnderlinedTextField) -> Void)?
    public var onEndEditing: ((UnderlinedTextField) -> Void)?
    public var onTextChanged: ((UnderlinedTextField) -> Void)?
    public var onShouldReturn: ((UnderlinedTextField) -> Void)?
    public var onActionButtonTap: ((UnderlinedTextField, UIButton) -> Void)?
    public var onValidateFail: ((UnderlinedTextField) -> Void)?
    public var onHeightChanged: ((CGFloat) -> Void)?
    public var onDateChanged: ((Date) -> Void)?
    public var onContainerStateChanged: ((FieldContainerState) -> Void)?

    // MARK: - Initialization

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureServices()
        configureAppearance()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UIView

    override open func awakeFromNib() {
        super.awakeFromNib()
        configureServices()
        configureAppearance()
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateUI()
        perfromOnContainerStateChangedCall()
        setup(textFieldMode: mode)
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        updateUI()
    }

    // MARK: - RespondableField

    public var nextInput: UIResponder? {
        didSet {
            textField.returnKeyType = nextInput == nil ? .default : .next
            toolbar?.updateNavigationButtons()
        }
    }
    public var previousInput: UIResponder? {
        didSet {
            toolbar?.updateNavigationButtons()
        }
    }
    open override var isFirstResponder: Bool {
        return textField.isFirstResponder
    }
    open override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    open override var canBecomeFirstResponder: Bool {
        return self.window != nil
    }

    // MARK: - Public Methods

    /// Allows you to change placeholder services for text field
    public func setup(placeholderServices: [AbstractPlaceholderService]) {
        self.placeholderServices = placeholderServices
        for service in placeholderServices {
            service.provide(superview: self.view, field: textField)
            service.configurePlaceholder(fieldState: state,
                                         containerState: containerState)
            service.updateContent(fieldState: state, containerState: containerState)
        }
    }

    /// Allows you to add new placeholder service
    public func add(placeholderService service: AbstractPlaceholderService) {
        service.provide(superview: self.view, field: textField)
        service.configurePlaceholder(fieldState: state,
                                     containerState: containerState)
        service.updateContent(fieldState: state, containerState: containerState)
        placeholderServices.append(service)
    }

    /// Allows you to set constraint on view height, this constraint will be changed if view height is changed later
    public func setup(heightConstraint: NSLayoutConstraint) {
        self.heightConstraint = heightConstraint
    }

    /// Allows you to set some string as hint message
    public func setup(hint: String) {
        guard !hint.isEmpty else {
            return
        }
        hintService?.setup(hintMessage: hint)
        hintService?.setupHintText(hint)
    }

    /// Allows you to set optional string as text.
    /// - Parameters:
    ///     - text: text for setup
    ///     - ignoreFormatter: allows you apply format from `maskFormatter` or ignore it,
    ///     false by default
    ///     - validateText: allows you disable automatic text validation on this action,
    ///     true by default
    public func setup(text: String?,
                      ignoreFormatter: Bool = false,
                      validateText: Bool = true) {
        if let formatter = maskFormatter, !ignoreFormatter {
            formatter.format(string: text, field: textField)
        } else {
            textField.text = text
        }
        if validateText {
            validate()
        }
        updateUI()
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
            hintService?.setupHintText(message)
        }
        updateUI()
    }

    /// Method performs validate logic, updates all UI elements and returns you `isValid` value
    @discardableResult
    public func validate(force: Bool = false) -> Bool {
        if !error || force {
            // case if user didn't activate this text field (or you want force validate it)
            validate()
            updateUI()
        }
        return !error
    }

    /// Clear text, reset error and update all UI elements - reset to default state
    public func reset() {
        textField.text = ""
        hintService?.setupHintIfNeeded()
        error = false
        updateUI()
    }

    /// Reset only error state and update all UI elements
    public func resetErrorState() {
        error = false
        updateUI()
    }

}

// MARK: - Configure

private extension UnderlinedTextField {

    func configureServices() {
        fieldService = FieldService(field: textField,
                                    configuration: configuration.textField,
                                    backgroundConfiguration: configuration.background)
        hintService = HintService(hintLabel: hintLabel,
                                  configuration: configuration.hint,
                                  heightLayoutPolicy: heightLayoutPolicy)
        lineService = LineService(superview: self,
                                  field: textField,
                                  configuration: configuration.line)
    }

    func configureAppearance() {
        fieldService?.setup(configuration: configuration.textField,
                            backgroundConfiguration: configuration.background)
        hintService?.setup(configuration: configuration.hint)
        lineService?.setup(configuration: configuration.line)
        for service in placeholderServices {
            service.provide(superview: self.view, field: textField)
        }

        fieldService?.configureBackground()
        fieldService?.configure(textField: textField)
        hintService?.configureHintLabel()
        lineService?.configureLineView(fieldState: state)
        for service in placeholderServices {
            service.configurePlaceholder(fieldState: state,
                                         containerState: containerState)
        }

        configureActionButton()
        textField.delegate = maskFormatter?.delegateForTextField() ?? self
        textField.addTarget(self, action: #selector(textfieldEditingChange(_:)), for: .editingChanged)
    }

    func configureActionButton() {
        actionButton.isHidden = true
    }

}

// MARK: - Actions

extension UnderlinedTextField {

    @IBAction private func tapOnActionButton(_ sender: UIButton) {
        onActionButtonTap?(self, sender)
        guard case .password = mode else {
            return
        }
        textField.isSecureTextEntry.toggle()
        textField.fixCursorPosition()
        updatePasswordButtonIcon()
    }

    @objc
    open func textfieldEditingChange(_ textField: UITextField) {
        removeError()
        performOnTextChangedCall()
        updatePasswordButtonVisibility()
        for service in placeholderServices {
            service.updateAfterTextChanged(fieldState: state)
        }
    }

}

// MARK: - UITextFieldDelegate

extension UnderlinedTextField: UITextFieldDelegate {

    open func textFieldDidBeginEditing(_ textField: UITextField) {
        state = .active
        onBeginEditing?(self)
    }

    open func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        validateWithPolicy()
        state = .normal
        onEndEditing?(self)
    }

    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard
            let text = textField.text,
            let textRange = Range(range, in: text),
            !validateWithFormatter,
            let maxLength = self.maxLength
        else {
            return true
        }

        let newText = text.replacingCharacters(in: textRange, with: string)
        return newText.count <= maxLength
    }

    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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

    open func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        maskFormatter?.textField(textField, didFillMandatoryCharacters: complete, didExtractValue: value)
        removeError()
        performOnTextChangedCall()
        updatePasswordButtonVisibility()
        for service in placeholderServices {
            service.updateAfterTextChanged(fieldState: state)
        }
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
        if let returnAction = onShouldReturn {
            returnAction(self)
        } else {
            textField.resignFirstResponder()
        }
    }

    public func switchToPreviousInput() {
        switchToResponder(responder: previousInput)
    }

    public func switchToNextInput() {
        switchToResponder(responder: nextInput)
    }

}

// MARK: - DateTextField

extension UnderlinedTextField: DateTextField {

    public func processDateChange(_ date: Date, text: String) {
        setup(text: text)
        onDateChanged?(date)
    }

}

// MARK: - PickerTextField

extension UnderlinedTextField: PickerTextField {

    public func processValueChange(_ value: String) {
        setup(text: value)
        performOnTextChangedCall()
    }

}

// MARK: - Private Methods

private extension UnderlinedTextField {

    func updateUI(animated: Bool = false) {
        fieldService?.updateContent(containerState: containerState)
        hintService?.updateContent(containerState: containerState)
        lineService?.updateContent(fieldState: state,
                                   containerState: containerState,
                                   strategy: .height)
        for service in placeholderServices {
            service.updateContent(fieldState: state, containerState: containerState)
        }

        updateViewHeight()
        updatePasswordButtonVisibility()
    }

    func validateWithPolicy() {
        switch validationPolicy {
        case .always:
            validate()
        case .notEmptyText:
            if !textField.isEmpty {
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
                hintService?.setupHintText(message)
            }
        } else if let currentValidator = validator {
            let (isValid, errorMessage) = currentValidator.validate(textField.text)
            error = !isValid
            if let message = errorMessage, !isValid {
                hintService?.setupHintText(message)
            }
        }
        if error {
            onValidateFail?(self)
        }
    }

    func setup(textFieldMode: TextFieldMode) {
        switch textFieldMode {
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
        for service in placeholderServices {
            service.update(useIncreasedRightPadding: !actionButton.isHidden,
                           fieldState: state)
        }
    }

    func removeError() {
        if error {
            hintService?.setupHintIfNeeded()
            error = false
            updateUI()
        }
    }

    func enableTextField() {
        state = .normal
        textField.isEnabled = true
        updateUI()
        /// fix for bug, when text field not changing his textColor on iphone 6+
        let text = textField.text
        textField.text = text
    }

    func disableTextField() {
        state = .disabled
        textField.isEnabled = false
        updateUI()
        /// fix for bug, when text field not changing his textColor on iphone 6+
        let text = textField.text
        textField.text = text
    }

    func performOnTextChangedCall() {
        isInteractionOccured = isInteractionOccured ? isInteractionOccured : !textField.isEmpty
        isTextChanged = isTextChanged ? isTextChanged : !textField.isEmpty
        onTextChanged?(self)
    }

    func perfromOnContainerStateChangedCall() {
        onContainerStateChanged?(containerState)
    }

    func switchToResponder(responder: UIResponder?) {
        if let input = responder as? RespondableField {
            guard input.canBecomeFirstResponder else {
                return
            }
            _ = input.becomeFirstResponder()
        } else {
            previousInput?.becomeFirstResponder()
        }
    }

}

// MARK: - Updating

private extension UnderlinedTextField {

    func updateViewHeight() {
        switch heightLayoutPolicy {
        case .fixed:
            break
        case .flexible(let minHeight, let bottomSpace):
            let hintHeight: CGFloat = hintService?.hintLabelHeight(containerState: containerState) ?? 0
            let actualViewHeight = hintLabel.frame.origin.y + hintHeight + bottomSpace
            let viewHeight = max(minHeight, actualViewHeight)
            guard lastViewHeight != viewHeight else {
                return
            }
            lastViewHeight = viewHeight
            heightConstraint?.constant = viewHeight
            onHeightChanged?(viewHeight)
        case .elastic(let minHeight, let bottomSpace, let ignoreEmptyHint):
            let viewHeight: CGFloat
            let hintHeight: CGFloat = hintService?.hintLabelHeight(containerState: containerState) ?? 0

            if hintHeight != 0 || !ignoreEmptyHint {
                let actualViewHeight = hintLabel.frame.origin.y + hintHeight + bottomSpace
                viewHeight = max(minHeight, actualViewHeight)
            } else {
                viewHeight = minHeight
            }

            guard lastViewHeight != viewHeight else {
                return
            }
            lastViewHeight = viewHeight
            heightConstraint?.constant = viewHeight
            onHeightChanged?(viewHeight)
        }
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

    func updatePasswordButtonVisibility() {
        guard case .password(let behavior) = mode else {
            return
        }

        let alpha: CGFloat
        switch behavior {
        case .alwaysVisible:
            actionButton.alpha = 1
            return
        case .visibleOnNotEmptyText:
            alpha = textField.isEmpty ? 0 : 1
        case .visibleAfterFirstEntry:
            alpha = isTextChanged ? 1 : 0
        }

        guard alpha != actionButton.alpha else {
            return
        }
        let duration = alpha == 0 ? 0 : AnimationTime.default
        UIView.animate(withDuration: duration) { [weak self] in
            self?.actionButton.alpha = alpha
        }
    }

}
