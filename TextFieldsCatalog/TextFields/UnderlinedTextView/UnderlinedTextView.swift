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
open class UnderlinedTextView: InnerDesignableView, ResetableField {

    // MARK: - IBOutlets

    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var hintLabel: UILabel!
    @IBOutlet private weak var clearButton: IconButton!

    // MARK: - NSLayoutConstraints

    @IBOutlet private weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textViewBottomConstraint: NSLayoutConstraint!

    // MARK: - Private Properties

    private var state: FieldState = .normal {
        didSet {
            updateUI()
        }
    }
    private var containerState: FieldContainerState {
        guard !error else {
            return .error
        }
        return state.containerState
    }

    private var maxLength: Int?

    private var error: Bool = false
    private var heightConstraint: NSLayoutConstraint?
    private var lastViewHeight: CGFloat = 0
    /// This flag set to `true` after first text changes and first call of validate() method
    private var isInteractionOccured = false

    // MARK: - Services

    private var fieldService: FieldService?
    private var hintService: HintService?
    private var lineService: LineService?
    private var placeholderService: AbstractPlaceholderService?

    // MARK: - Properties

    public var configuration = UnderlinedTextViewConfiguration() {
        didSet {
            configureAppearance()
            updateUI()
        }
    }
    public var validator: TextFieldValidation?
    public var hideClearButton = false
    public var responder: UIResponder {
        return self.textView
    }
    public var validationPolicy: ValidationPolicy = .always
    public var flexibleHeightPolicy = FlexibleHeightPolicy(minHeight: 77,
                                                           bottomOffset: 5)

    public var onBeginEditing: ((UnderlinedTextView) -> Void)?
    public var onEndEditing: ((UnderlinedTextView) -> Void)?
    public var onTextChanged: ((UnderlinedTextView) -> Void)?
    public var onShouldReturn: ((UnderlinedTextView) -> Void)?
    public var onValidateFail: ((UnderlinedTextView) -> Void)?
    public var onHeightChanged: ((CGFloat) -> Void)?
    public var toolbarView: UIView? {
        get {
            return textView.inputAccessoryView
        }
        set {
            textView.inputAccessoryView = newValue
        }
    }

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
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        updateUI()
    }

    // MARK: - Public Methods

    /// Allows you to install a placeholder, infoString in bottom label and maximum allowed string length
    public func configure(placeholder: String?, maxLength: Int?) {
        placeholderService?.setup(placeholder: placeholder)
        self.maxLength = maxLength
    }

    /// Allows you to set constraint on view height, this constraint will be changed if view height is changed later
    public func configure(heightConstraint: NSLayoutConstraint) {
        self.heightConstraint = heightConstraint
    }

    /// Allows you to set autocorrection and keyboardType for textView
    public func configure(correction: UITextAutocorrectionType?, keyboardType: UIKeyboardType?) {
        if let correction = correction {
            textView.autocorrectionType = correction
        }
        if let keyboardType = keyboardType {
            textView.keyboardType = keyboardType
        }
    }

    /// Allows you to set autocapitalization type for textView
    public func configure(autocapitalizationType: UITextAutocapitalizationType) {
        textView.autocapitalizationType = autocapitalizationType
    }

    /// Allows you to set textContent type for textView
    public func configureContentType(_ contentType: UITextContentType) {
        textView.textContentType = contentType
    }

    /// Allows you to set text in textView and update all UI elements
    public func setText(_ text: String?) {
        textView.text = text ?? ""
        validate()
        updateUI()
    }

    /// Return current input string in textView
    public func currentText() -> String {
        return textView.text
    }

    /// Allows to set accessibilityIdentifier for textView and its internal elements
    public func setTextFieldIdentifier(_ identifier: String) {
        view.accessibilityIdentifier = identifier
        textView.accessibilityIdentifier = identifier + AccessibilityIdentifiers.field
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
        textView.text = ""
        hintService?.setupHintIfNeeded()
        error = false
        updateUI()
        updateClearButtonVisibility()
    }

    /// Reset only error state and update all UI elements
    public func resetErrorState() {
        error = false
        updateUI()
    }

    /// Disable textView
    public func disableTextField() {
        state = .disabled
        textView.isEditable = false
        updateUI()
        /// fix for bug, when text field not changing his textColor on iphone 6+
        textView.text = currentText()
    }

    /// Enable text field
    public func enableTextField() {
        state = .normal
        textView.isEditable = true
        updateUI()
        /// fix for bug, when text field not changing his textColor on iphone 6+
        textView.text = currentText()
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
        hintService?.setup(hintMessage: hint)
        hintService?.setupHintText(hint)
    }

    /// Return true, if field is current firstResponder
    public func isCurrentFirstResponder() -> Bool {
        return textView.isFirstResponder
    }

    /// Makes textField is current first responder
    public func makeFirstResponder() {
        _ = textView.becomeFirstResponder()
    }

}

// MARK: - Configure

private extension UnderlinedTextView {

    func configureServices() {
        fieldService = FieldService(field: textView,
                                    configuration: configuration.textField,
                                    backgroundConfiguration: configuration.background)
        hintService = HintService(hintLabel: hintLabel,
                                  configuration: configuration.hint,
                                  heightLayoutPolicy: .elastic(minHeight: 0, bottomSpace: 0, ignoreEmptyHint: false))
        lineService = LineService(superview: self,
                                  field: textView,
                                  configuration: configuration.line)
        placeholderService = PlaceholderServiceFactory().produce(type: configuration.placeholder,
                                                                 superview: self,
                                                                 field: textView)
    }

    func configureAppearance() {
        fieldService?.setup(configuration: configuration.textField,
                            backgroundConfiguration: configuration.background)
        hintService?.setup(configuration: configuration.hint)
        lineService?.setup(configuration: configuration.line)
        placeholderService = PlaceholderServiceFactory().produce(type: configuration.placeholder,
                                                                 superview: self,
                                                                 field: textView)

        fieldService?.configureBackground()
        fieldService?.configure(textView: textView)
        placeholderService?.configurePlaceholder(fieldState: state,
                                                 containerState: containerState)
        hintService?.configureHintLabel()
        lineService?.configureLineView(fieldState: state)

        configureClearButton()
        textView.delegate = self
    }

    func configureClearButton() {
        clearButton.setImageForAllState(configuration.clearButton.image,
                                        normalColor: configuration.clearButton.normalColor,
                                        pressedColor: configuration.clearButton.pressedColor)
        updateClearButtonVisibility()
    }

}

// MARK: - Actions

private extension UnderlinedTextView {

    @IBAction func tapOnClearButton(_ sender: UIButton) {
        reset()
    }

}

// MARK: - UITextViewDelegate

extension UnderlinedTextView: UITextViewDelegate {

    public func textViewDidBeginEditing(_ textView: UITextView) {
        state = .active
        onBeginEditing?(self)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        validateWithPolicy()
        state = .normal
        onEndEditing?(self)
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
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

    public func textViewDidChange(_ textView: UITextView) {
        updateClearButtonVisibility()
        removeError()
        performOnTextChangedCall()
        placeholderService?.updatePlaceholderVisibility(fieldState: state)
    }

}

// MARK: - Private Methods

private extension UnderlinedTextView {

    func updateUI(animated: Bool = false) {
        fieldService?.updateContent(containerState: containerState)
        hintService?.updateContent(containerState: containerState)
        placeholderService?.updateContent(fieldState: state,
                                          containerState: containerState)

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
                hintService?.setupHintText(message)
            }
        }
        if error {
            onValidateFail?(self)
        }
    }

    func removeError() {
        if error {
            hintService?.setupHintIfNeeded()
            error = false
            updateUI()
        } else {
            updateViewHeight()
            lineService?.updateLineFrame(fieldState: state)
        }
    }

    func performOnTextChangedCall() {
        if !isInteractionOccured {
            isInteractionOccured = !textView.isEmpty
        }
        onTextChanged?(self)
    }

}

// MARK: - Updating

private extension UnderlinedTextView {

    func updateViewHeight() {
        let hintHeight = hintService?.hintLabelHeight(containerState: containerState) ?? 0
        let textHeight = textViewHeight()
        let actualViewHeight = textHeight + hintHeight + freeVerticalSpace()
        let viewHeight = max(flexibleHeightPolicy.minHeight, actualViewHeight)

        textViewHeightConstraint.constant = textHeight
        view.layoutIfNeeded()

        guard lastViewHeight != viewHeight else {
            return
        }
        lastViewHeight = viewHeight
        heightConstraint?.constant = viewHeight
        onHeightChanged?(viewHeight)
    }

    func updateClearButtonVisibility() {
        clearButton.isHidden = textView.text.isEmpty || hideClearButton
    }

}

// MARK: - Computed values

private extension UnderlinedTextView {

    func freeVerticalSpace() -> CGFloat {
        return textViewTopConstraint.constant + textViewBottomConstraint.constant + flexibleHeightPolicy.bottomOffset
    }

    func textViewHeight() -> CGFloat {
        return textView.text.height(forWidth: textView.bounds.size.width, font: configuration.textField.font, lineHeight: nil)
    }

}
