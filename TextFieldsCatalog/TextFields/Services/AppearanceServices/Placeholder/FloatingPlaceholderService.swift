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
        case font, frame, color
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
        placeholder.frame = placeholderPosition(fieldState: fieldState)
        placeholder.truncationMode = CATextLayerTruncationMode.end
        superview?.layer.addSublayer(placeholder)
    }

    public func updateContent(fieldState: FieldState,
                              containerState: FieldContainerState) {
        updateTypes(UpdateType.allCases, fieldState: fieldState, containerState: containerState)
    }

    public func update(useIncreasedRightPadding: Bool, fieldState: FieldState) {
        self.useIncreasedRightPadding = useIncreasedRightPadding
        updateTypes([.frame], fieldState: fieldState, containerState: nil)
    }

}

// MARK: - Private Updates

private extension FloatingPlaceholderService {

    func updateTypes(_ types: [UpdateType],
                     fieldState: FieldState,
                     containerState: FieldContainerState?) {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = types.flatMap {
            return getAnimationsForUpdateType($0,
                                              fieldState: fieldState,
                                              containerState: containerState)
        }
        groupAnimation.fillMode = .forwards
        groupAnimation.duration = AnimationTime.default
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

        placeholder.removeAllAnimations()
        placeholder.add(groupAnimation, forKey: "mixed_animation")
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

            placeholder.foregroundColor = endColor
            return [colorAnimation]
        case .font:
            let startFontSize: CGFloat = currentPlaceholderFontSize()
            let endFontSize: CGFloat = placeholderFontSize(fieldState: fieldState)

            let fontSizeAnimation = CABasicAnimation(keyPath: "fontSize")
            fontSizeAnimation.fromValue = startFontSize
            fontSizeAnimation.toValue = endFontSize

            placeholder.fontSize = endFontSize
            return [fontSizeAnimation]
        case .frame:
            let fromFrame = currentPlaceholderPosition()
            let toFrame = placeholderPosition(fieldState: fieldState)

            let positionAnimation = CABasicAnimation(keyPath: "position")
            positionAnimation.fromValue = CGPoint(x: fromFrame.midX, y: fromFrame.midY)
            positionAnimation.toValue = CGPoint(x: toFrame.midX, y: toFrame.midY)

            let boundsAnimation = CABasicAnimation(keyPath: "bounds")
            boundsAnimation.fromValue = CGRect(origin: .zero, size: fromFrame.size)
            boundsAnimation.toValue = CGRect(origin: .zero, size: toFrame.size)

            placeholder.frame = toFrame
            return [positionAnimation, boundsAnimation]
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

    func currentPlaceholderPosition() -> CGRect {
        return placeholder.presentation()?.frame ?? placeholder.frame
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
