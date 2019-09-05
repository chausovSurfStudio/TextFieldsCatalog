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

    // MARK: - Struct

    public struct FlexibleHeightPolicy {
        let minHeight: CGFloat
        /// offset between hint label and view bottom
        let bottomOffset: CGFloat
    }

    // MARK: - Constants

    private enum Constants {
        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var hintLabel: UILabel!
    @IBOutlet private weak var clearButton: IconButton!

    // MARK: - NSLayoutConstraints

    @IBOutlet private weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textViewBottomConstraint: NSLayoutConstraint!

    // MARK: - Private Properties

    private let lineView = UIView()
    private var state: FieldState = .normal {
        didSet {
            updateUI()
        }
    }

    private let placeholder: CATextLayer = CATextLayer()
    private var hintMessage: String?
    private var maxLength: Int?

    private var error: Bool = false
    private var heightConstraint: NSLayoutConstraint?
    private var lastViewHeight: CGFloat = 0
    private var lastLinePosition: CGRect = .zero

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

    /// Allows you to install a placeholder, infoString in bottom label and maximum allowed string length
    public func configure(placeholder: String?, maxLength: Int?) {
        self.placeholder.string = placeholder
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
        setupHintText(hintMessage ?? "")
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
        hintMessage = hint
        setupHintText(hint)
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

    func configureAppearance() {
        configureBackground()
        configurePlaceholder()
        configureTextView()
        configureHintLabel()
        configureLineView()
        configureClearButton()
    }

    func configureBackground() {
        view.backgroundColor = configuration.background.color
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
        lastLinePosition = lineView.frame
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
        validate()
        state = .normal
        onEndEditing?(self)
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard
            let currentText = textView.text,
            let textRange = Range(range, in: currentText),
            let maxLength = self.maxLength else {
                return true
        }
        let newText = currentText.replacingCharacters(in: textRange, with: text)
        return newText.count <= maxLength
    }

    public func textViewDidChange(_ textView: UITextView) {
        updateClearButtonVisibility()
        removeError()
        onTextChanged?(self)
    }

}

// MARK: - Private Methods

private extension UnderlinedTextView {

    func updateUI(animated: Bool = false) {
        updateHintLabelColor()
        updateHintLabelVisibility()

        updatePlaceholderColor()
        updatePlaceholderPosition()
        updatePlaceholderFont()

        updateTextColor()
        updateViewHeight()

        updateLineViewColor()
        updateLineFrame()
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
            updateViewHeight()
            updateLineFrame()
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
        return textView.text.isEmpty
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

    func updateLineViewColor() {
        let color = lineColor()
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.lineView.backgroundColor = color
        }
    }

    func updateLineFrame() {
        let actualPosition = linePosition()
        guard lastLinePosition != actualPosition else {
            return
        }
        lineView.frame = actualPosition
        view.layoutIfNeeded()
    }

    func updateClearButtonVisibility() {
        clearButton.isHidden = textView.text.isEmpty || hideClearButton
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
        var lineFrame = view.bounds.inset(by: UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16))
        lineFrame.size.height = height
        lineFrame.origin.y += textView.frame.maxY
        return lineFrame
    }

    func lineHeight() -> CGFloat {
        return state == .active ? configuration.line.increasedHeight : configuration.line.defaultHeight
    }

    func hintTextColor() -> UIColor {
        return configuration.hint.colors.suitableColor(fieldState: state, isActiveError: error)
    }

    func freeVerticalSpace() -> CGFloat {
        return textViewTopConstraint.constant + textViewBottomConstraint.constant + flexibleHeightPolicy.bottomOffset
    }

    func textViewHeight() -> CGFloat {
        return textView.text.height(forWidth: textView.bounds.size.width, font: configuration.textField.font, lineHeight: nil)
    }

}
