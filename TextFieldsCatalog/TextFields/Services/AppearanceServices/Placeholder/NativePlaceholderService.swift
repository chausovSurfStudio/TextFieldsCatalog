//
//  NativePlaceholderService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 28/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit

/**
 Default variant of placeholder service which implements logic of `native`-placeholder.

 This service allows you to imitate behavior of default native placeholder.
 - Attention:
    - For more information - see also info about `NativePlaceholderConfiguration` in documentation.
*/
public final class NativePlaceholderService: AbstractPlaceholderService {

    // MARK: - Private Properties

    private let placeholder = UILabel()
    private weak var superview: UIView?
    private weak var field: InputField?
    private var configuration: NativePlaceholderConfiguration
    private var useIncreasedRightPadding = false

    // MARK: - Initialization

    public init(configuration: NativePlaceholderConfiguration) {
        self.configuration = configuration
    }

    // MARK: - Deinitialization

    deinit {
        placeholder.removeFromSuperview()
    }

    // MARK: - AbstractPlaceholderService

    public func provide(superview: UIView, field: InputField?) {
        self.superview = superview
        self.field = field
    }

    public func setup(placeholder: String?) {
        self.placeholder.text = placeholder
    }

    public func configurePlaceholder(fieldState: FieldState,
                                     containerState: FieldContainerState) {
        placeholder.removeFromSuperview()
        placeholder.text = placeholder.text ?? ""
        placeholder.font = configuration.font
        placeholder.textColor = configuration.colors.suitableColor(state: containerState)
        placeholder.frame = placeholderPosition()
        placeholder.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        superview?.addSubview(placeholder)
    }

    public func updateContent(fieldState: FieldState,
                              containerState: FieldContainerState,
                              animated: Bool) {
        updatePlaceholderColor(containerState: containerState)
        updateAfterTextChangedPrivate(fieldState: fieldState, animated: animated)
    }

    public func update(useIncreasedRightPadding: Bool,
                       fieldState: FieldState,
                       animated: Bool) {
        self.useIncreasedRightPadding = useIncreasedRightPadding
        placeholder.frame = placeholderPosition()
    }

    public func updateAfterTextChanged(fieldState: FieldState) {
        updateAfterTextChangedPrivate(fieldState: fieldState, animated: true)
    }

}

// MARK: - Private Methods

private extension NativePlaceholderService {

    func updateAfterTextChangedPrivate(fieldState: FieldState, animated: Bool) {
        guard textIsEmpty() else {
            setupPlaceholderVisibility(isVisible: false, animated: animated)
            return
        }

        let isVisible: Bool
        if configuration.useAsMainPlaceholder {
            isVisible = !(fieldState == .active && configuration.behavior == .hideOnFocus)
        } else {
            isVisible = fieldState == .active && configuration.behavior == .hideOnInput
        }
        setupPlaceholderVisibility(isVisible: isVisible, animated: animated)
    }

    func placeholderPosition() -> CGRect {
        guard let superview = superview else {
            return .zero
        }
        var insets = configuration.insets
        if useIncreasedRightPadding {
            insets.right = configuration.increasedRightPadding
        }
        var placeholderFrame = superview.bounds.inset(by: insets)
        placeholderFrame.size.height = configuration.height
        return placeholderFrame
    }

    func updatePlaceholderColor(containerState: FieldContainerState) {
        placeholder.textColor = configuration.colors.suitableColor(state: containerState)
    }

    func textIsEmpty() -> Bool {
        return field?.inputText?.isEmpty ?? true
    }

    func setupPlaceholderVisibility(isVisible: Bool, animated: Bool) {
        let animationBlock: () -> Void = {
            self.placeholder.alpha = isVisible ? 1 : 0
        }
        if isVisible && animated {
            UIView.animate(withDuration: AnimationTime.default, animations: animationBlock)
        } else {
            animationBlock()
        }
    }

}
