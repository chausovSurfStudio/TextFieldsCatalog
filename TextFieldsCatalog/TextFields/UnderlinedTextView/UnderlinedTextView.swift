//
//  UnderlinedTextView.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 27/05/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

/// Class for custom textView. Contains UITextView, top floating placeholder, underline line under textView and bottom label with some info.
/// Also have button for text clear, but you can hide it.
/// Standart height equals 77.
open class UnderlinedTextView: UIView, ResetableField, RespondableField {

    // MARK: - Subviews

    private let textView = UITextView()
    private let hintLabel = UILabel()
    private let clearButton = IconButton()

    // MARK: - NSLayoutConstraints

    private var textViewHeightConstraint: NSLayoutConstraint!
    private var textViewTopConstraint: NSLayoutConstraint!
    private var textViewBottomConstraint: NSLayoutConstraint!

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
    private var lastViewHeight: CGFloat = 77 {
        didSet {
            if oldValue != lastViewHeight {
                invalidateIntrinsicContentSize()
                onHeightChanged?(lastViewHeight)
            }
        }
    }

    /// This flag set to `true` after first text changes and first call of validate() method
    private var isInteractionOccured = false

    // MARK: - Services

    private var fieldService: FieldService?
    private var hintService: AbstractHintService = HintService(configuration: .default)
    private var lineService: LineService?
    private var placeholderServices: [AbstractPlaceholderService] = [FloatingPlaceholderService(configuration: .defaultForTextView)]
    private var layoutService: TextViewLayoutServiceAbstract = TextViewLayoutServiceDefault(constants: .default)

    // MARK: - Properties

    public var field: UITextView {
        return textView
    }
    public var text: String {
        get {
            return trimSpaces ? trimmedText() : textView.text
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
    public var configuration = UnderlinedTextViewConfiguration() {
        didSet {
            configureAppearance()
            updateUI()
        }
    }
    public var validator: TextFieldValidation?
    public var toolbar: ToolBarInterface? {
        didSet {
            textView.inputAccessoryView = toolbar
            toolbar?.guidedField = self
            toolbar?.updateNavigationButtons()
        }
    }
    public var maxLength: Int?
    public var hideClearButton = false
    public var validationPolicy: ValidationPolicy = .always
    public var trimSpaces: Bool = false
    public var flexibleHeightPolicy = FlexibleHeightPolicy(minHeight: 77,
                                                           bottomOffset: 5,
                                                           ignoreEmptyHint: true)
    public var maxTextContainerHeight: CGFloat?
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

    public var onBeginEditing: ((UnderlinedTextView) -> Void)?
    public var onEndEditing: ((UnderlinedTextView) -> Void)?
    public var onTextChanged: ((UnderlinedTextView) -> Void)?
    public var onShouldReturn: ((UnderlinedTextView) -> Void)?
    public var onValidateFail: ((UnderlinedTextView) -> Void)?
    public var onHeightChanged: ((CGFloat) -> Void)?
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

    override open  func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateUI()
        perfromOnContainerStateChangedCall()
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        updateUI()
    }

    override open var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: lastViewHeight)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        lineService?.updateLineFrame(fieldState: state)
    }

    // MARK: - RespondableField

    public var nextInput: UIResponder? {
        didSet {
            toolbar?.updateNavigationButtons()
        }
    }
    public var previousInput: UIResponder? {
        didSet {
            toolbar?.updateNavigationButtons()
        }
    }
    open override var isFirstResponder: Bool {
        return textView.isFirstResponder
    }
    open override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    open override var canBecomeFirstResponder: Bool {
        return self.window != nil
    }

    // MARK: - Public Methods

    /// Allows you to change placeholder services for text view
    public func setup(placeholderServices: [AbstractPlaceholderService]) {
        self.placeholderServices = placeholderServices
        for service in placeholderServices {
            service.provide(superview: self, field: textView)
            service.configurePlaceholder(fieldState: state,
                                         containerState: containerState)
            service.updateContent(fieldState: state, containerState: containerState)
        }
    }

    /// Allows you to add new placeholder service
    public func add(placeholderService service: AbstractPlaceholderService) {
        service.provide(superview: self, field: textView)
        service.configurePlaceholder(fieldState: state,
                                     containerState: containerState)
        service.updateContent(fieldState: state, containerState: containerState)
        placeholderServices.append(service)
    }

    /// Allows you to change default hint service
    public func setup(hintService: AbstractHintService) {
        self.hintService = hintService
        hintService.provide(label: hintLabel)
        hintService.configureAppearance()
        hintService.updateContent(containerState: containerState,
                                  heightLayoutPolicy: .elastic(policy: flexibleHeightPolicy))
    }

    /// Allows you to set some string as hint message
    public func setup(hint: String) {
        hintService.setup(plainHint: hint)
    }

    /// Allows you to refresh set of states, when hint message or error message
    /// should be visible
    public func setup(visibleHintStates: HintVisibleStates) {
        self.hintService.setup(visibleHintStates: visibleHintStates)
        updateUI()
    }

    public func setup(layoutService: TextViewLayoutServiceAbstract) {
        self.layoutService = layoutService
        let layoutOutput = layoutService.layout(textView: textView,
                                                hintLabel: hintLabel,
                                                clearButton: clearButton,
                                                in: self)
        textViewHeightConstraint = layoutOutput.textViewHeightConstraint
        textViewTopConstraint = layoutOutput.textViewTopConstraint
        textViewBottomConstraint = layoutOutput.textViewBottomConstraint
    }

    /// Allows you to set optional string as text.
    /// Also you can disable automatic validation on this action.
    public func setup(text: String?, validateText: Bool = true) {
        textView.text = text ?? ""
        if validateText {
            validate()
        }
        updateUI()
    }

    /// Allows to set accessibilityIdentifier for textView and its internal elements
    public func setTextFieldIdentifier(_ identifier: String) {
        accessibilityIdentifier = identifier
        textView.accessibilityIdentifier = identifier + AccessibilityIdentifiers.field
        hintLabel.accessibilityIdentifier = identifier + AccessibilityIdentifiers.hint
    }

    /// Allows to set view in 'error' state, optionally allows you to set the error message. If errorMessage is nil - label keeps the previous info message
    public func setError(with errorMessage: String?, animated: Bool) {
        error = true
        hintService.setup(errorHint: errorMessage)
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
        textView.text = ""
        hintService.showHint()
        error = false
        updateUI()
        updateClearButtonVisibility()
    }

    /// Reset only error state and update all UI elements
    public func resetErrorState() {
        error = false
        updateUI()
    }

}

// MARK: - Configure

private extension UnderlinedTextView {

    func configureServices() {
        fieldService = FieldService(field: textView,
                                    configuration: configuration.textField,
                                    backgroundConfiguration: configuration.background)
        lineService = LineService(superview: self,
                                  field: textView,
                                  configuration: configuration.line)
    }

    func configureAppearance() {
        fieldService?.setup(configuration: configuration.textField,
                            backgroundConfiguration: configuration.background)
        lineService?.setup(configuration: configuration.line)
        hintService.provide(label: hintLabel)
        for service in placeholderServices {
            service.provide(superview: self, field: textView)
        }

        fieldService?.configureBackground()
        fieldService?.configure(textView: textView)
        lineService?.configureLineView(fieldState: state)
        hintService.configureAppearance()
        for service in placeholderServices {
            service.configurePlaceholder(fieldState: state,
                                         containerState: containerState)
        }

        setup(layoutService: layoutService)

        configureClearButton()
        textView.delegate = self
    }

    func configureClearButton() {
        clearButton.setImageForAllState(configuration.clearButton.image,
                                        normalColor: configuration.clearButton.normalColor,
                                        pressedColor: configuration.clearButton.pressedColor)
        clearButton.addTarget(self, action: #selector(tapOnClearButton(_:)), for: .touchUpInside)
        updateClearButtonVisibility()
    }

}

// MARK: - Actions

private extension UnderlinedTextView {

    @objc
    func tapOnClearButton(_ sender: UIButton) {
        reset()
    }

}

// MARK: - GuidedTextField

extension UnderlinedTextView: GuidedTextField {

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
            textView.resignFirstResponder()
        }
    }

    public func switchToPreviousInput() {
        switchToResponder(previousInput)
    }

    public func switchToNextInput() {
        switchToResponder(nextInput)
    }

}

// MARK: - UITextViewDelegate

extension UnderlinedTextView: UITextViewDelegate {

    open func textViewDidBeginEditing(_ textView: UITextView) {
        state = .active
        onBeginEditing?(self)
    }

    open func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if trimSpaces {
            textView.text = trimmedText()
        }
        return true
    }

    open func textViewDidEndEditing(_ textView: UITextView) {
        validateWithPolicy()
        state = .normal
        onEndEditing?(self)
    }

    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard
            let currentText = textView.text,
            let textRange = Range(range, in: currentText),
            let maxLength = self.maxLength
        else {
            return true
        }
        let newText = currentText.replacingCharacters(in: textRange, with: text)
        return newText.count <= maxLength
    }

    open func textViewDidChange(_ textView: UITextView) {
        updateClearButtonVisibility()
        removeError()
        performOnTextChangedCall()
        for service in placeholderServices {
            service.updateAfterTextChanged(fieldState: state)
        }
    }

}

// MARK: - Private Methods

private extension UnderlinedTextView {

    func updateUI(animated: Bool = false) {
        fieldService?.updateContent(containerState: containerState)
        hintService.updateContent(containerState: containerState,
                                  heightLayoutPolicy: .elastic(policy: flexibleHeightPolicy))
        for service in placeholderServices {
            service.updateContent(fieldState: state, containerState: containerState)
        }

        updateViewHeight()
        lineService?.updateContent(fieldState: state,
                                   containerState: containerState,
                                   strategy: .frame)
    }

    func validateWithPolicy() {
        switch validationPolicy {
        case .always:
            validate()
        case .notEmptyText:
            if !textView.isEmpty {
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
        if let currentValidator = validator {
            let (isValid, errorMessage) = currentValidator.validate(textView.text)
            error = !isValid
            if let message = errorMessage, !isValid {
                hintService.setup(errorHint: message)
            }
        }
        if error {
            onValidateFail?(self)
        }
    }

    func removeError() {
        if error {
            hintService.showHint()
            error = false
            updateUI()
        } else {
            updateViewHeight()
            lineService?.updateLineFrame(fieldState: state)
        }
    }

    func disableTextField() {
        state = .disabled
        textView.isEditable = false
        updateUI()
        /// fix for bug, when text field not changing his textColor on iphone 6+
        let text = textView.text
        textView.text = text
    }

    func enableTextField() {
        state = .normal
        textView.isEditable = true
        updateUI()
        /// fix for bug, when text field not changing his textColor on iphone 6+
        let text = textView.text
        textView.text = text
    }

    func performOnTextChangedCall() {
        isInteractionOccured = isInteractionOccured ? isInteractionOccured : !textView.isEmpty
        onTextChanged?(self)
    }

    func perfromOnContainerStateChangedCall() {
        onContainerStateChanged?(containerState)
    }

    func switchToResponder(_ responder: UIResponder?) {
        if let input = responder as? RespondableField {
            guard input.canBecomeFirstResponder else {
                return
            }
            _ = input.becomeFirstResponder()
        } else {
            responder?.becomeFirstResponder()
        }
    }

    func trimmedText() -> String {
        return textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

}

// MARK: - Updating

private extension UnderlinedTextView {

    func updateViewHeight() {
        let hintHeight = hintService.hintHeight(containerState: containerState)
        let textHeight = min(textViewHeight(), maxTextContainerHeight ?? CGFloat.greatestFiniteMagnitude)
        let freeSpace = freeVerticalSpace(isEmptyHint: hintHeight == 0)
        let actualViewHeight = textHeight + hintHeight + freeSpace
        let viewHeight = max(flexibleHeightPolicy.minHeight, actualViewHeight)

        textViewHeightConstraint.constant = textHeight
        layoutIfNeeded()
        lastViewHeight = viewHeight
    }

    func updateClearButtonVisibility() {
        clearButton.isHidden = textView.text.isEmpty || hideClearButton
    }

}

// MARK: - Computed values

private extension UnderlinedTextView {

    func freeVerticalSpace(isEmptyHint: Bool) -> CGFloat {
        let values = [
            textViewTopConstraint.constant,
            textViewBottomConstraint.constant,
            isEmptyHint && flexibleHeightPolicy.ignoreEmptyHint ? 0 : flexibleHeightPolicy.bottomOffset
        ]
        return values.reduce(0, +)
    }

    func textViewHeight() -> CGFloat {
        return textView.text.height(forWidth: textView.bounds.size.width, font: configuration.textField.font, lineHeight: nil)
    }

}
