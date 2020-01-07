//
//  FloatingPlaceholderService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 07/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

final class FloatingPlaceholderService {

    // MARK: - Constants

    private enum Constants {
        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - Properties

    private let superview: InnerDesignableView
    private let placeholder: CATextLayer
    private let field: InputField?

    private var configuration: FloatingPlaceholderConfiguration

    // MARK: - Initialization

    init(superview: InnerDesignableView,
         placeholder: CATextLayer,
         field: InputField?,
         configuration: FloatingPlaceholderConfiguration) {
        self.superview = superview
        self.placeholder = placeholder
        self.field = field
        self.configuration = configuration
    }

    // MARK: - Internal Methods

    func setup(configuration: FloatingPlaceholderConfiguration) {
        self.configuration = configuration
    }

    func configurePlaceholder(state: FieldContainerState) {
        placeholder.removeFromSuperlayer()
        placeholder.string = ""
        placeholder.font = configuration.font
        placeholder.fontSize = configuration.bigFontSize
        placeholder.foregroundColor = placeholderColor(state: state)
        placeholder.contentsScale = UIScreen.main.scale
        placeholder.frame = placeholderPosition(state: state)
        placeholder.truncationMode = CATextLayerTruncationMode.end
        superview.layer.addSublayer(placeholder)
    }

    func updatePlaceholderColor(state: FieldContainerState) {
        let startColor: CGColor = currentPlaceholderColor()
        let endColor: CGColor = placeholderColor(state: state)
        placeholder.foregroundColor = endColor

        let colorAnimation = CABasicAnimation(keyPath: "foregroundColor")
        colorAnimation.fromValue = startColor
        colorAnimation.toValue = endColor
        colorAnimation.duration = Constants.animationDuration
        colorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        placeholder.add(colorAnimation, forKey: nil)
    }

    func updatePlaceholderPosition(isNativePlaceholder: Bool, state: FieldContainerState) {
        guard !isNativePlaceholder else {
            return
        }
        let startPosition: CGRect = currentPlaceholderPosition()
        let endPosition: CGRect = placeholderPosition(state: state)
        placeholder.frame = endPosition

        let frameAnimation = CABasicAnimation(keyPath: "frame")
        frameAnimation.fromValue = startPosition
        frameAnimation.toValue = endPosition
        frameAnimation.duration = Constants.animationDuration
        frameAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        placeholder.add(frameAnimation, forKey: nil)
    }

    func updatePlaceholderVisibility(isNativePlaceholder: Bool) {
        placeholder.isHidden = isNativePlaceholder && !textIsEmpty()
    }

    func updatePlaceholderFont(state: FieldContainerState) {
        let startFontSize: CGFloat = currentPlaceholderFontSize()
        let endFontSize: CGFloat = placeholderFontSize(state: state)
        placeholder.fontSize = endFontSize

        let fontSizeAnimation = CABasicAnimation(keyPath: "fontSize")
        fontSizeAnimation.fromValue = startFontSize
        fontSizeAnimation.toValue = endFontSize
        fontSizeAnimation.duration = Constants.animationDuration
        fontSizeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        placeholder.add(fontSizeAnimation, forKey: nil)
    }

}

// MARK: - Private Methods

private extension FloatingPlaceholderService {

    func currentPlaceholderColor() -> CGColor {
        return placeholder.foregroundColor ?? configuration.bottomColors.normal.cgColor
    }

    func placeholderColor(state: FieldContainerState) -> CGColor {
        let placeholderOnTop = shouldMovePlaceholderOnTop(state: state)
        let colors = placeholderOnTop ? configuration.topColors : configuration.bottomColors
        return colors.suitableColor(state: state).cgColor
    }

    func currentPlaceholderPosition() -> CGRect {
        return placeholder.frame
    }

    func placeholderPosition(state: FieldContainerState) -> CGRect {
        let placeholderOnTop = shouldMovePlaceholderOnTop(state: state)
        let targetInsets = placeholderOnTop ? configuration.topInsets : configuration.bottomInsets
        var placeholderFrame = superview.view.bounds.inset(by: targetInsets)
        placeholderFrame.size.height = configuration.height
        return placeholderFrame
    }

    func currentPlaceholderFontSize() -> CGFloat {
        return placeholder.fontSize
    }

    func placeholderFontSize(state: FieldContainerState) -> CGFloat {
        return shouldMovePlaceholderOnTop(state: state) ? configuration.smallFontSize : configuration.bigFontSize
    }

    /// Return true, if floating placeholder should placed on top in current state, false in other case
    func shouldMovePlaceholderOnTop(state: FieldContainerState) -> Bool {
        return state == .active || !textIsEmpty()
    }

    /// Return true, if current input string is empty
    func textIsEmpty() -> Bool {
        return field?.inputText?.isEmpty ?? true
    }

}
