//
//  FloatingPlaceholderService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 07/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

/**
 Default variant of placeholder service which implements logic of `floating`-placeholder.

 Placeholder-container in this service is a CATextLayer, which changes his color, font and position when field changed his state.
 - Attention:
    - For more information - see also info about `FloatingPlaceholderConfiguration` in documentation.
 */
public final class FloatingPlaceholderService: AbstractPlaceholderService {

    // MARK: - Private Properties

    private let placeholder: CATextLayer = CATextLayer()
    private weak var superview: UIView?
    private weak var field: InputField?
    private var configuration: FloatingPlaceholderConfiguration
    private var useIncreasedRightPadding = false

    // MARK: - Initialization

    public init(configuration: FloatingPlaceholderConfiguration) {
        self.configuration = configuration
    }

    // MARK: - AbstractPlaceholderService

    public func provide(superview: UIView, field: InputField?) {
        self.superview = superview
        self.field = field
    }

    public func setup(placeholder: String?) {
        self.placeholder.string = placeholder
    }

    public func configurePlaceholder(fieldState: FieldState, containerState: FieldContainerState) {
        placeholder.removeFromSuperlayer()
        placeholder.string = placeholder.string ?? ""
        placeholder.font = configuration.font
        placeholder.fontSize = configuration.bigFontSize
        placeholder.foregroundColor = placeholderColor(fieldState: fieldState, containerState: containerState)
        placeholder.contentsScale = UIScreen.main.scale
        placeholder.frame = placeholderPosition(fieldState: fieldState)
        placeholder.truncationMode = CATextLayerTruncationMode.end
        superview?.layer.addSublayer(placeholder)
    }

    public func updateContent(fieldState: FieldState,
                              containerState: FieldContainerState) {
        updatePlaceholderColor(fieldState: fieldState, containerState: containerState)
        updatePlaceholderPosition(fieldState: fieldState)
        updatePlaceholderFont(fieldState: fieldState)
    }

    public func update(useIncreasedRightPadding: Bool, fieldState: FieldState) {
        self.useIncreasedRightPadding = useIncreasedRightPadding
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
        guard let superview = superview else {
            return .zero
        }
        let placeholderOnTop = shouldMovePlaceholderOnTop(state: fieldState)
        var targetInsets = placeholderOnTop ? configuration.topInsets : configuration.bottomInsets
        if useIncreasedRightPadding {
            targetInsets.right = configuration.increasedRightPadding
        }
        var placeholderFrame = superview.bounds.inset(by: targetInsets)
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
