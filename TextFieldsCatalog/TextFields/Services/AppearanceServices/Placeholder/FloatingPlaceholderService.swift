//
//  FloatingPlaceholderService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 07/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

final class FloatingPlaceholderService: AbstractPlaceholderService {

    // MARK: - Private Properties

    private let placeholder: CATextLayer = CATextLayer()
    private let superview: InnerDesignableView
    private let field: InputField?

    private var configuration: FloatingPlaceholderConfiguration

    // MARK: - Initialization

    init(superview: InnerDesignableView,
         field: InputField?,
         configuration: FloatingPlaceholderConfiguration) {
        self.superview = superview
        self.field = field
        self.configuration = configuration
    }

    // MARK: - AbstractPlaceholderService

    var useIncreasedRightPadding = false

    func setup(placeholder: String?) {
        self.placeholder.string = placeholder
    }

    func configurePlaceholder(fieldState: FieldState, containerState: FieldContainerState) {
        placeholder.removeFromSuperlayer()
        placeholder.string = ""
        placeholder.font = configuration.font
        placeholder.fontSize = configuration.bigFontSize
        placeholder.foregroundColor = placeholderColor(fieldState: fieldState, containerState: containerState)
        placeholder.contentsScale = UIScreen.main.scale
        placeholder.frame = placeholderPosition(fieldState: fieldState)
        placeholder.truncationMode = CATextLayerTruncationMode.end
        superview.layer.addSublayer(placeholder)
    }

    func updateContent(fieldState: FieldState,
                       containerState: FieldContainerState) {
        updatePlaceholderColor(fieldState: fieldState, containerState: containerState)
        updatePlaceholderPosition(fieldState: fieldState)
        updatePlaceholderFont(fieldState: fieldState)
    }

    func updatePlaceholderFrame(fieldState: FieldState) {
        updatePlaceholderPosition(fieldState: fieldState)
    }

}

// MARK: - Private Updates

private extension FloatingPlaceholderService {

    func updatePlaceholderColor(fieldState: FieldState, containerState: FieldContainerState) {
        let startColor: CGColor = currentPlaceholderColor()
        let endColor: CGColor = placeholderColor(fieldState: fieldState, containerState: containerState)
        placeholder.foregroundColor = endColor

        let colorAnimation = CABasicAnimation(keyPath: "foregroundColor")
        colorAnimation.fromValue = startColor
        colorAnimation.toValue = endColor
        colorAnimation.duration = AnimationTime.default
        colorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        placeholder.add(colorAnimation, forKey: nil)
    }

    func updatePlaceholderPosition(fieldState: FieldState) {
        let startPosition: CGRect = currentPlaceholderPosition()
        let endPosition: CGRect = placeholderPosition(fieldState: fieldState)
        placeholder.frame = endPosition

        let frameAnimation = CABasicAnimation(keyPath: "frame")
        frameAnimation.fromValue = startPosition
        frameAnimation.toValue = endPosition
        frameAnimation.duration = AnimationTime.default
        frameAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        placeholder.add(frameAnimation, forKey: nil)
    }

    func updatePlaceholderFont(fieldState: FieldState) {
        let startFontSize: CGFloat = currentPlaceholderFontSize()
        let endFontSize: CGFloat = placeholderFontSize(fieldState: fieldState)
        placeholder.fontSize = endFontSize

        let fontSizeAnimation = CABasicAnimation(keyPath: "fontSize")
        fontSizeAnimation.fromValue = startFontSize
        fontSizeAnimation.toValue = endFontSize
        fontSizeAnimation.duration = AnimationTime.default
        fontSizeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        placeholder.add(fontSizeAnimation, forKey: nil)
    }

}

// MARK: - Private Methods

private extension FloatingPlaceholderService {

    func currentPlaceholderColor() -> CGColor {
        return placeholder.foregroundColor ?? configuration.bottomColors.normal.cgColor
    }

    func placeholderColor(fieldState: FieldState, containerState: FieldContainerState) -> CGColor {
        let placeholderOnTop = shouldMovePlaceholderOnTop(state: fieldState)
        let colors = placeholderOnTop ? configuration.topColors : configuration.bottomColors
        return colors.suitableColor(state: containerState).cgColor
    }

    func currentPlaceholderPosition() -> CGRect {
        return placeholder.frame
    }

    func placeholderPosition(fieldState: FieldState) -> CGRect {
        let placeholderOnTop = shouldMovePlaceholderOnTop(state: fieldState)
        var targetInsets = placeholderOnTop ? configuration.topInsets : configuration.bottomInsets
        if useIncreasedRightPadding {
            targetInsets.right = configuration.increasedRightPadding
        }
        var placeholderFrame = superview.view.bounds.inset(by: targetInsets)
        placeholderFrame.size.height = configuration.height
        return placeholderFrame
    }

    func currentPlaceholderFontSize() -> CGFloat {
        return placeholder.fontSize
    }

    func placeholderFontSize(fieldState: FieldState) -> CGFloat {
        return shouldMovePlaceholderOnTop(state: fieldState) ? configuration.smallFontSize : configuration.bigFontSize
    }

    /// Return true, if floating placeholder should placed on top in current state, false in other case
    func shouldMovePlaceholderOnTop(state: FieldState) -> Bool {
        return state == .active || !textIsEmpty()
    }

    /// Return true, if current input string is empty
    func textIsEmpty() -> Bool {
        return field?.inputText?.isEmpty ?? true
    }

}
