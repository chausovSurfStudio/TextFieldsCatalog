//
//  UnderlinedTextView.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 27/05/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

/// Class for custom textView. Contains UITextView, top floating placeholder, underline line under textView and bottom label with some info.
/// Standart height equals 77.
open class UnderlinedTextView: InnerDesignableView, ResetableField {

    // MARK: - Struct

    public struct FlexibleHeightPolicy {
        let minHeight: CGFloat
        let bottomOffset: CGFloat
    }

    // MARK: - Enums

    private enum UnderlinedTextViewState {
        /// textField not in focus
        case normal
        /// state with active textField
        case active
        /// state for disabled textField
        case disabled
    }

    // MARK: - Constants

    private enum Constants {
        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var hintLabel: UILabel!

    // MARK: - NSLayoutConstraints

    @IBOutlet private weak var textViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Private Properties

    private let lineView = UIView()
    private var state: UnderlinedTextViewState = .normal {
        didSet {
            updateUI()
        }
    }

    private let placeholder: CATextLayer = CATextLayer()
    private var hintMessage: String?
    private var maxLength: Int?

    private var error: Bool = false
    private var nextInput: UIResponder?
    private var previousInput: UIResponder?
    private var heightConstraint: NSLayoutConstraint?
    private var lastViewHeight: CGFloat = 0

    // MARK: - Properties

    public var configuration = UnderlinedTextFieldConfiguration() {
        didSet {
            configureAppearance()
            updateUI()
        }
    }
    public var validator: TextFieldValidation?
    public var hideOnReturn: Bool = true
    public var responder: UIResponder {
        return self.textView
    }
    override open var inputView: UIView? {
        get {
            return textView.inputView
        }
        set {
            textView.inputView = newValue
        }
    }
    public var flexibleHeightPolicy = FlexibleHeightPolicy(minHeight: 77,
                                                           bottomOffset: 5)

    public var onBeginEditing: ((UnderlinedTextView) -> Void)?
    public var onEndEditing: ((UnderlinedTextView) -> Void)?
    public var onTextChanged: ((UnderlinedTextView) -> Void)?
    public var onShouldReturn: ((UnderlinedTextView) -> Void)?
    public var onValidateFail: ((UnderlinedTextView) -> Void)?
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
            textView.autocorrectionType = correction
        }
        if let keyboardType = keyboardType {
            textView.keyboardType = keyboardType
        }
    }

    /// Allows you to set autocapitalization type for textField
    public func configure(autocapitalizationType: UITextAutocapitalizationType) {
        textView.autocapitalizationType = autocapitalizationType
    }

    /// Allows you to set textContent type for textField
    public func configureContentType(_ contentType: UITextContentType) {
        textView.textContentType = contentType
    }

    /// Allows you to set text in textField and update all UI elements
    public func setText(_ text: String?) {
        textView.text = text ?? ""
        validate()
        updateUI()
    }

    /// Return current input string in textField
    public func currentText() -> String {
        return textView.text
    }

    /// This method hide keyboard, when textField will be activated (e.g., for textField with date, which connectes with DatePicker)
    public func hideKeyboard() {
        textView.inputView = UIView()
    }

    /// Allows to set accessibilityIdentifier for textField and its internal elements
    public func setTextFieldIdentifier(_ identifier: String) {
        view.accessibilityIdentifier = identifier
        textView.accessibilityIdentifier = identifier + AccessibilityIdentifiers.field
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
        textView.text = ""
        error = false
        updateUI()
    }

    /// Reset only error state and update all UI elements
    public func resetErrorState() {
        error = false
        updateUI()
    }

    /// Disable text field
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
        hintMessage = hint
        setupHintText(hint)
    }

    /// Return true, if field is current firstResponder
    public func isCurrentFirstResponder() -> Bool {
        return textView.isFirstResponder
    }

    /// Sets next responder, which will be activated after 'Next' button in keyboard will be pressed
    public func setNextResponder(_ nextResponder: UIResponder) {
        textView.returnKeyType = .next
        nextInput = nextResponder
    }

    /// Sets previous responder, which will be activated after 'Back' button in keyboard toolbar will be pressed.
    /// 'Back' button appears only into the topView in custom input views, which you can find in this library.
    public func setPreviousResponder(_ nextResponder: UIResponder) {
        previousInput = nextResponder
    }

    /// Makes textField is current first responder
    public func makeFirstResponder() {
        _ = textView.becomeFirstResponder()
    }

    /// Allows you to manage keyboard returnKeyType
    public func setReturnKeyType(_ type: UIReturnKeyType) {
        textView.returnKeyType = type
    }

}

// MARK: - Configure

private extension UnderlinedTextView {

    func configureAppearance() {
        configureBackground()
        configurePlaceholder()
        configureTextView()
        configureHintLabel()
        configureLineView()
    }

    func configureBackground() {
        view.backgroundColor = UIColor.black//configuration.background.color
        textView.backgroundColor = UIColor.clear
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

    func configureTextView() {
        textView.delegate = self
        textView.font = configuration.textField.font
        textView.textColor = configuration.textField.colors.normal
        textView.tintColor = configuration.textField.tintColor
        textView.returnKeyType = .done
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.contentOffset = CGPoint(x: 0, y: 0)
        textView.isScrollEnabled = false
    }

    func configureHintLabel() {
        hintLabel.textColor = configuration.hint.colors.normal
        hintLabel.font = configuration.hint.font
        hintLabel.text = ""
        hintLabel.numberOfLines = 0
        hintLabel.alpha = 0
    }

    func configureLineView() {
        if lineView.superview == nil, configuration.line.insets != .zero {
            view.addSubview(lineView)
        }
        lineView.frame = linePosition()
        lineView.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth]
        lineView.layer.cornerRadius = configuration.line.cornerRadius
        lineView.layer.masksToBounds = true
        lineView.backgroundColor = configuration.line.colors.normal
    }

}

// MARK: - UITextViewDelegate

extension UnderlinedTextView: UITextViewDelegate {

    public func textViewDidBeginEditing(_ textView: UITextView) {
        state = .active
        onBeginEditing?(self)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        validate()
        state = .normal
        onEndEditing?(self)
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let text = textView.text, let textRange = Range(range, in: text) else {
            return true
        }

        let newText = text.replacingCharacters(in: textRange, with: text)
        var isValid = true
        if let maxLength = self.maxLength {
            isValid = newText.count <= maxLength
        }

        return isValid
    }

    public func textViewDidChange(_ textView: UITextView) {
        removeError()
        onTextChanged?(self)
    }

}

// MARK: - Private Methods

private extension UnderlinedTextView {

    func updateUI(animated: Bool = false) {
        updateHintLabelColor()
        updateHintLabelVisibility()
        updateHintLabelPosition()

        updateLineViewColor()
        updateLineViewHeight()

        updatePlaceholderColor()
        updatePlaceholderPosition()
        updatePlaceholderFont()

        updateTextColor()
        updateViewHeight()
    }

    func validate() {
        if let currentValidator = validator {
            let (isValid, errorMessage) = currentValidator.validate(textView.text)
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
        } else {
            updateHintLabelPosition()
            updateViewHeight()
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
        guard let text = textView.text else {
            return true
        }
        return text.isEmpty
    }

    func setupHintText(_ hintText: String) {
        hintLabel.attributedText = hintText.with(lineHeight: configuration.hint.lineHeight,
                                                 font: configuration.hint.font,
                                                 color: hintLabel.textColor)
    }

}

// MARK: - Updating

private extension UnderlinedTextView {

    func updateHintLabelColor() {
        hintLabel.textColor = hintTextColor()
    }

    func updateHintLabelVisibility() {
        let alpha: CGFloat = shouldShowHint() ? 1 : 0
        let duration: TimeInterval = shouldShowHint() ? Constants.animationDuration : 0
        UIView.animate(withDuration: duration) { [weak self] in
            self?.hintLabel.alpha = alpha
        }
    }

    func updateHintLabelPosition() {

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

    func updateTextColor() {
        textView.textColor = textColor()
    }

    func updateViewHeight() {
        let hintHeight = hintLabelHeight()
        let textHeight = textViewHeight()
        let actualViewHeight = 23 + textHeight + 9 + hintHeight + flexibleHeightPolicy.bottomOffset
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

    func textViewHeight() -> CGFloat {
        return textView.text.height(forWidth: textView.bounds.size.width, font: configuration.textField.font, lineHeight: nil)
    }

}

// MARK: - Computed values

private extension UnderlinedTextView {

    func hintLabelHeight() -> CGFloat {
        let hintIsVisible = shouldShowHint()
        if let hint = hintLabel.text, hintIsVisible {
            return hint.height(forWidth: hintLabel.bounds.size.width, font: configuration.hint.font, lineHeight: configuration.hint.lineHeight)
        }
        return 0
    }

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

    func linePosition() -> CGRect {
        let height = lineHeight()
        var lineFrame = view.bounds.inset(by: configuration.line.insets)
        lineFrame.size.height = height
        return lineFrame
    }

    func lineHeight() -> CGFloat {
        return state == .active ? configuration.line.increasedHeight : configuration.line.defaultHeight
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
