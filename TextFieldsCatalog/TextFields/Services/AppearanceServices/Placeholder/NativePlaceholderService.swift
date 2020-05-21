//
//  NativePlaceholderService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 28/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

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

    // MARK: - AbstractPlaceholderService

    public func provide(superview: UIView, field: InputField?) {
        self.superview = superview
        self.field = field
    }

    public func setup(placeholder: String?) {
        self.placeholder.text = placeholder
    }

    public func configurePlaceholder(fieldState: FieldState, containerState: FieldContainerState) {
        placeholder.removeFromSuperview()
        placeholder.text = ""
        placeholder.font = configuration.font
        placeholder.textColor = configuration.colors.suitableColor(state: containerState)
        placeholder.frame = placeholderPosition()
        placeholder.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        superview?.addSubview(placeholder)
    }

    public func updateContent(fieldState: FieldState,
                              containerState: FieldContainerState) {
        updatePlaceholderColor(containerState: containerState)
        updateAfterTextChanged(fieldState: fieldState)
    }

    public func update(useIncreasedRightPadding: Bool, fieldState: FieldState) {
        self.useIncreasedRightPadding = useIncreasedRightPadding
        placeholder.frame = placeholderPosition()
    }

    public func updateAfterTextChanged(fieldState: FieldState) {
        guard textIsEmpty() else {
            setupPlaceholderVisibility(isVisible: false)
            return
        }

        let isVisible: Bool
        if configuration.useAsMainPlaceholder {
            isVisible = !(fieldState == .active && configuration.behavior == .hideOnFocus)
        } else {
            isVisible = fieldState == .active && configuration.behavior == .hideOnInput
        }
        setupPlaceholderVisibility(isVisible: isVisible)
    }

}

// MARK: - Private Methods

private extension NativePlaceholderService {

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

    func setupPlaceholderVisibility(isVisible: Bool) {
        let animationTime = isVisible ? AnimationTime.default : 0
        UIView.animate(withDuration: animationTime) { [weak self] in
            self?.placeholder.alpha = isVisible ? 1 : 0
        }
    }

}
