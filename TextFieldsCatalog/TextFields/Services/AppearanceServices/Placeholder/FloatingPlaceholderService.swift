//
//  FloatingPlaceholderService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 07/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit

/**
 Default variant of placeholder service which implements logic of `floating`-placeholder.

 Placeholder-container in this service is a CATextLayer, which changes his color, font and position when field changed his state.
 - Attention:
    - For more information - see also info about `FloatingPlaceholderConfiguration` in documentation.
 */
public final class FloatingPlaceholderService: AbstractPlaceholderService {

    // MARK: - Nestes Types

    enum UpdateType: CaseIterable {
        case frame, color, font
    }

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

    // MARK: - Deinitialization

    deinit {
        placeholder.removeFromSuperlayer()
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
        placeholder.frame = placeholderFrame(fieldState: fieldState)
        placeholder.truncationMode = CATextLayerTruncationMode.end
        superview?.layer.addSublayer(placeholder)
    }

    public func updateContent(fieldState: FieldState,
                              containerState: FieldContainerState,
                              animated: Bool) {
        updateTypes(UpdateType.allCases,
                    fieldState: fieldState,
                    containerState: containerState,
                    animated: animated)
    }

    public func update(useIncreasedRightPadding: Bool,
                       fieldState: FieldState,
                       animated: Bool) {
        self.useIncreasedRightPadding = useIncreasedRightPadding
        updateTypes([.frame],
                    fieldState: fieldState,
                    containerState: nil,
                    animated: animated)
    }

}

// MARK: - Private Updates

private extension FloatingPlaceholderService {

    func updateTypes(_ types: [UpdateType],
                     fieldState: FieldState,
                     containerState: FieldContainerState?,
                     animated: Bool) {
        // The idea of updating layer with animation was to do it with `CAAnimationGroup` (how realized below).
        // While animation without animation should be made without `CAAnimationGroup` - just
        // fill with final properties inside `CATransaction` (to avoid implicit animation).
        // Bust in practice, CATextLayer animated in CATransaction very bad - sometimes implicit animation
        // still exists.
        // The solution of this problem - to make changing state of layer with `CAAnimationGroup` with
        // very small `duration`

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = types.flatMap {
            return getAnimationsForUpdateType($0,
                                              fieldState: fieldState,
                                              containerState: containerState)
        }
        groupAnimation.duration = animated ? AnimationTime.default : 0.001
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        setFinalPropertiesWithoutAnimationForUpdateTypes(types,
                                                         fieldState: fieldState,
                                                         containerState: containerState)
        placeholder.add(groupAnimation, forKey: "placeholder_mixed_animation")
    }

    func getAnimationsForUpdateType(_ type: UpdateType,
                                    fieldState: FieldState,
                                    containerState: FieldContainerState?) -> [CAAnimation] {
        switch type {
        case .color:
            guard let containerState = containerState else {
                return []
            }
            let startColor: CGColor = currentPlaceholderColor()
            let endColor: CGColor = placeholderColor(fieldState: fieldState, containerState: containerState)

            let colorAnimation = CABasicAnimation(keyPath: "foregroundColor")
            colorAnimation.fromValue = startColor
            colorAnimation.toValue = endColor

            return [colorAnimation]
        case .font:
            let startFontSize: CGFloat = currentPlaceholderFontSize()
            let endFontSize: CGFloat = placeholderFontSize(fieldState: fieldState)

            let fontSizeAnimation = CABasicAnimation(keyPath: "fontSize")
            fontSizeAnimation.fromValue = startFontSize
            fontSizeAnimation.toValue = endFontSize

            return [fontSizeAnimation]
        case .frame:
            let fromPosition = currentPlaceholderPosition()
            let fromBounds = currentPlaceholderBounds()
            let (toPosition, toBounds) = placeholderPositionAndBounds(fieldState: fieldState)

            let positionAnimation = CABasicAnimation(keyPath: "position")
            positionAnimation.fromValue = fromPosition
            positionAnimation.toValue = toPosition

            let boundsAnimation = CABasicAnimation(keyPath: "bounds")
            boundsAnimation.fromValue = fromBounds
            boundsAnimation.toValue = toBounds

            return [positionAnimation, boundsAnimation]
        }
    }

    func setFinalPropertiesWithoutAnimationForUpdateTypes(_ types: [UpdateType],
                                                          fieldState: FieldState,
                                                          containerState: FieldContainerState?) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        types.forEach {
            setFinalPropertiesWithoutAnimationForUpdateType($0, fieldState: fieldState, containerState: containerState)
        }
        CATransaction.commit()
    }

    func setFinalPropertiesWithoutAnimationForUpdateType(_ type: UpdateType,
                                                         fieldState: FieldState,
                                                         containerState: FieldContainerState?) {
        switch type {
        case .color:
            guard let containerState = containerState else {
                return
            }
            placeholder.foregroundColor = placeholderColor(fieldState: fieldState, containerState: containerState)
        case .font:
            placeholder.fontSize = placeholderFontSize(fieldState: fieldState)
        case .frame:
            placeholder.frame = placeholderFrame(fieldState: fieldState)
        }
    }

}

// MARK: - Private Methods

private extension FloatingPlaceholderService {

    func currentPlaceholderColor() -> CGColor {
        return placeholder.presentation()?.foregroundColor ?? placeholder.foregroundColor ?? configuration.bottomColors.normal.cgColor
    }

    func placeholderColor(fieldState: FieldState, containerState: FieldContainerState) -> CGColor {
        let placeholderOnTop = shouldMovePlaceholderOnTop(state: fieldState)
        let colors = placeholderOnTop ? configuration.topColors : configuration.bottomColors
        return colors.suitableColor(state: containerState).cgColor
    }

    func currentPlaceholderPosition() -> CGPoint {
        return placeholder.presentation()?.position ?? placeholder.position
    }

    func currentPlaceholderBounds() -> CGRect {
        return placeholder.presentation()?.bounds ?? placeholder.bounds
    }

    func placeholderFrame(fieldState: FieldState) -> CGRect {
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

    func placeholderPositionAndBounds(fieldState: FieldState) -> (CGPoint, CGRect) {
        let frame = placeholderFrame(fieldState: fieldState)
        return (
            CGPoint(x: frame.midX, y: frame.midY),
            CGRect(origin: .zero, size: frame.size)
        )
    }

    func currentPlaceholderFontSize() -> CGFloat {
        return placeholder.presentation()?.fontSize ?? placeholder.fontSize
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
