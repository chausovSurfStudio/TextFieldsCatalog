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
    private let leftOffset: CGFloat
    private let topOffset: CGFloat
    private let height: CGFloat
    private let font: UIFont
    private let color: UIColor

    private var superview: UIView?
    private var field: InputField?
    private var textIsEmpty: Bool {
        return field?.inputText?.isEmpty ?? true
    }

    // MARK: - Initialization

    init(leftOffset: CGFloat,
         topOffset: CGFloat,
         height: CGFloat,
         font: UIFont,
         color: UIColor) {
        self.leftOffset = leftOffset
        self.topOffset = topOffset
        self.height = height
        self.font = font
        self.color = color
    }

    // MARK: - AbstractPlaceholderService

    public func provide(superview: UIView, field: InputField?) {
        self.superview = superview
        self.field = field
    }

    public func setup(placeholder: String?) {
        self.placeholder.text = placeholder
        updatePlaceholderWidth()
    }

    public func configurePlaceholder(fieldState: FieldState, containerState: FieldContainerState) {
        placeholder.removeFromSuperview()
        placeholder.text = ""
        placeholder.font = font
        placeholder.textColor = color
        placeholder.frame = initialPosition()
        placeholder.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        superview?.addSubview(placeholder)
    }

    public func updateContent(fieldState: FieldState,
                              containerState: FieldContainerState) {
        updateAfterTextChanged(fieldState: fieldState)
    }

    public func updateAfterTextChanged(fieldState: FieldState) {
        updatePlaceholderOffset()
        setupPlaceholderVisibility(isVisible: !textIsEmpty)
    }

}

// MARK: - Private Methods

private extension CurrencyPlaceholderService {

    func initialPosition() -> CGRect {
        let width = placeholderWidth()
        let frame = CGRect(x: 0, y: topOffset, width: width, height: height)
        return frame
    }

    func updatePlaceholderOffset() {
        let attributes: [NSAttributedString.Key: Any] = [.font: placeholder.font as Any]
        let width = (field?.inputText ?? "").width(forHeight: height, attributes: attributes)
        let xPosition = (field?.frame.minX ?? 0) + width + leftOffset
        print(xPosition)
        placeholder.frame.origin.x = xPosition
    }

    func updatePlaceholderWidth() {
        let width = placeholderWidth()
        placeholder.frame.size = CGSize(width: width, height: placeholder.frame.height)
    }

    func placeholderWidth() -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        return (placeholder.text ?? "").width(forHeight: height, attributes: attributes)
    }

    func setupPlaceholderVisibility(isVisible: Bool) {
        placeholder.alpha = isVisible ? 1 : 0
    }

}
