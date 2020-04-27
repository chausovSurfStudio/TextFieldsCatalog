//
//  StaticPlaceholderService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 27/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

final class StaticPlaceholderService: AbstractPlaceholderService {

    // MARK: - Private Properties

    private let placeholder = UILabel()
    private let superview: InnerDesignableView
    private let field: InputField?

    private var configuration: StaticPlaceholderConfiguration

    // MARK: - Initialization

    init(superview: InnerDesignableView,
         field: InputField?,
         configuration: StaticPlaceholderConfiguration) {
        self.superview = superview
        self.field = field
        self.configuration = configuration
    }

    // MARK: - AbstractPlaceholderService

    // this value doesn't uses in this service
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
    }

    func updatePlaceholderFrame(fieldState: FieldState) {
        // this method doesn't use in this service
    }

}

private extension StaticPlaceholderService {

    func placeholderPosition() -> CGRect {
        var placeholderFrame = superview.view.bounds.inset(by: configuration.insets)
        placeholderFrame.size.height = configuration.height
        return placeholderFrame
    }

    func updatePlaceholderColor(containerState: FieldContainerState) {
        placeholder.textColor = configuration.colors.suitableColor(state: containerState)
    }

}
