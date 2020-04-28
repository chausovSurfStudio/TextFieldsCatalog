//
//  NativePlaceholderService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 28/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

final class NativePlaceholderService: AbstractPlaceholderService {

    // MARK: - Private Properties

    private let placeholder = UILabel()
    private let superview: InnerDesignableView
    private let field: InputField?

    private var configuration: NativePlaceholderConfiguration

    // MARK: - Initialization

    init(superview: InnerDesignableView,
         field: InputField?,
         configuration: NativePlaceholderConfiguration) {
        self.superview = superview
        self.field = field
        self.configuration = configuration
    }

    // MARK: - AbstractPlaceholderService

    var useIncreasedRightPadding = false

    func setup(placeholder: String?) {
        self.placeholder.text = placeholder
    }

    func configurePlaceholder(fieldState: FieldState, containerState: FieldContainerState) {
        placeholder.removeFromSuperview()
        placeholder.text = ""
        placeholder.font = configuration.font
        placeholder.textColor = configuration.colors.suitableColor(state: containerState)
        placeholder.frame = placeholderPosition()
        placeholder.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        superview.addSubview(placeholder)
    }

    func updateContent(fieldState: FieldState,
                       containerState: FieldContainerState) {
        updatePlaceholderColor(containerState: containerState)
        updatePlaceholderVisibility(fieldState: fieldState)
    }

    func updatePlaceholderFrame(fieldState: FieldState) {
        placeholder.frame = placeholderPosition()
    }

    func updatePlaceholderVisibility(fieldState: FieldState) {
        let visibilityByPurpose = configuration.useAsMainPlaceholder ? true : fieldState == .active
        let visibilityByBehavior: Bool
        switch configuration.behavior {
        case .hideOnFocus:
            visibilityByBehavior = fieldState != .active
        case .hideOnInput:
            visibilityByBehavior = textIsEmpty()
        }
        let isVisible = visibilityByPurpose && visibilityByBehavior

        let animationTime = isVisible ? AnimationTime.default : 0
        UIView.animate(withDuration: animationTime) { [weak self] in
            self?.placeholder.alpha = isVisible ? 1 : 0
        }
    }

}

// MARK: - Private Methods

private extension NativePlaceholderService {

    func placeholderPosition() -> CGRect {
        var insets = configuration.insets
        if useIncreasedRightPadding {
            insets.right = configuration.increasedRightPadding
        }
        var placeholderFrame = superview.view.bounds.inset(by: insets)
        placeholderFrame.size.height = configuration.height
        return placeholderFrame
    }

    func updatePlaceholderColor(containerState: FieldContainerState) {
        placeholder.textColor = configuration.colors.suitableColor(state: containerState)
    }

    func textIsEmpty() -> Bool {
        return field?.inputText?.isEmpty ?? true
    }

}
