//
//  CurrencyPlaceholderService.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 19/05/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import TextFieldsCatalog

final class CurrencyPlaceholderService: AbstractPlaceholderService {

    // MARK: - Private Properties

    private let placeholder = UILabel()
    private var superview: UIView?
    private var field: InputField?
    private var offset: CGFloat

    // MARK: - Initialization

    public init(offset: CGFloat) {
        self.offset = offset
    }

    // MARK: - AbstractPlaceholderService

    public func provide(superview: UIView, field: InputField?) {
        self.superview = superview
        self.field = field
    }

    public func setup(configuration: Any) {
    }

    public func setup(placeholder: String?) {
        self.placeholder.text = placeholder
    }

    public func configurePlaceholder(fieldState: FieldState, containerState: FieldContainerState) {
        placeholder.removeFromSuperview()
        placeholder.text = ""
//        placeholder.font = configuration.font
//        placeholder.textColor = configuration.colors.suitableColor(state: containerState)
//        placeholder.frame = placeholderPosition()
        placeholder.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        superview?.addSubview(placeholder)
    }

    public func updateContent(fieldState: FieldState,
                              containerState: FieldContainerState) {
//        updatePlaceholderColor(containerState: containerState)
//        updateAfterTextChanged(fieldState: fieldState)
    }

    public func updateAfterTextChanged(fieldState: FieldState) {
    }

}
