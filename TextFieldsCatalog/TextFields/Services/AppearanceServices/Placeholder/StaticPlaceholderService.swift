//
//  StaticPlaceholderService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 27/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

/**
 Default variant of placeholder service which implements logic of `static`-placeholder.

 Placeholder-container in this service is UILabel which have static textColor, font and position, which wouldn't be change on field state change.
*/
public final class StaticPlaceholderService: AbstractPlaceholderService {

    // MARK: - Private Properties

    private let placeholder = UILabel()
    private weak var superview: UIView?
    private var configuration: StaticPlaceholderConfiguration

    // MARK: - Initialization

    public init(configuration: StaticPlaceholderConfiguration) {
        self.configuration = configuration
    }

    // MARK: - AbstractPlaceholderService

    public func provide(superview: UIView, field: InputField?) {
        self.superview = superview
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
    }

}

// MARK: - Private Methods

private extension StaticPlaceholderService {

    func placeholderPosition() -> CGRect {
        guard let superview = superview else {
            return .zero
        }
        var placeholderFrame = superview.bounds.inset(by: configuration.insets)
        placeholderFrame.size.height = configuration.height
        return placeholderFrame
    }

    func updatePlaceholderColor(containerState: FieldContainerState) {
        placeholder.textColor = configuration.colors.suitableColor(state: containerState)
    }

}
