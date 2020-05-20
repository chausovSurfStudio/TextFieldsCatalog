//
//  CurrencyPlaceholderService.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 19/05/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import TextFieldsCatalog

final class CurrencyPlaceholderService: AbstractPlaceholderService {

    // MARK: - Constants

    private enum Constants {
        static let placeholderHeight: CGFloat = 50
    }

    // MARK: - Private Properties

    private let placeholder = UILabel()
    private let offset: CGFloat
    private let font: UIFont
    private let color: UIColor
    private let insets: UIEdgeInsets

    private var superview: UIView?
    private var field: InputField?
    private var textIsEmpty: Bool {
        return field?.inputText?.isEmpty ?? true
    }

    // MARK: - Initialization

    init(offset: CGFloat,
         font: UIFont,
         color: UIColor,
         insets: UIEdgeInsets) {
        self.offset = offset
        self.font = font
        self.color = color
        self.insets = insets
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
        placeholder.font = font
        placeholder.textColor = color
        placeholder.frame = placeholderPosition()
        placeholder.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        superview?.addSubview(placeholder)
    }

    public func updateContent(fieldState: FieldState,
                              containerState: FieldContainerState) {
        updateAfterTextChanged(fieldState: fieldState)
    }

    public func updateAfterTextChanged(fieldState: FieldState) {
        placeholder.frame = placeholderPosition()
        setupPlaceholderVisibility(isVisible: !textIsEmpty)
    }

}

// MARK: - Private Methods

private extension CurrencyPlaceholderService {

    func placeholderPosition() -> CGRect {
        guard let superview = superview else {
            return .zero
        }
        var placeholderFrame = superview.bounds.inset(by: insets)
        placeholderFrame.size.height = Constants.placeholderHeight
        return placeholderFrame
    }

    func setupPlaceholderVisibility(isVisible: Bool) {
        placeholder.alpha = isVisible ? 1 : 0
    }

}
