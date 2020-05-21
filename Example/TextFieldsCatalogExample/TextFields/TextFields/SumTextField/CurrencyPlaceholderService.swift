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
    private let insets: UIEdgeInsets
    private let height: CGFloat
    private let font: UIFont
    private let color: UIColor

    private weak var superview: UIView?
    private weak var field: InputField?
    private var textIsEmpty: Bool {
        return field?.inputText?.isEmpty ?? true
    }
    private var placeholderWidth: CGFloat = 0

    // MARK: - Initialization

    init(insets: UIEdgeInsets,
         height: CGFloat,
         font: UIFont,
         color: UIColor) {
        self.insets = insets
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
        placeholderWidth = calculatePlaceholderWidth()
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
        return CGRect(x: 0,
                      y: insets.top,
                      width: placeholderWidth,
                      height: height)
    }

    func updatePlaceholderOffset() {
        let attributes: [NSAttributedString.Key: Any] = [.font: placeholder.font as Any]
        let textWidth = (field?.inputText ?? "").width(forHeight: height, attributes: attributes)
        var xPosition = (field?.frame.minX ?? 0) + textWidth + insets.left

        let maxX = xPosition + placeholderWidth
        let superviewWidth = superview?.bounds.width ?? 0
        if maxX + insets.right > superviewWidth {
            xPosition = superviewWidth - insets.right - placeholderWidth
        }

        placeholder.frame.origin.x = xPosition
    }

    func updatePlaceholderWidth() {
        placeholder.frame.size = CGSize(width: placeholderWidth, height: placeholder.frame.height)
    }

    func calculatePlaceholderWidth() -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        return (placeholder.text ?? "").width(forHeight: height, attributes: attributes)
    }

    func setupPlaceholderVisibility(isVisible: Bool) {
        placeholder.alpha = isVisible ? 1 : 0
    }

}
