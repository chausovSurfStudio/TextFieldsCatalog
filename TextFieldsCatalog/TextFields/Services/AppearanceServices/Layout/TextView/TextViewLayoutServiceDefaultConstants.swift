//
//  TextViewLayoutServiceDefaultConstants.swift
//  TextFieldsCatalog
//
//  Created by al.filimonov on 10.04.2021.
//

import Foundation

public struct TextViewLayoutServiceDefaultConstants {

    // MARK: - Public Properties

    public var textViewTopMargin: CGFloat
    public var textViewLeadingMargin: CGFloat
    public var textViewTrailingMargin: CGFloat
    public var textViewHeight: CGFloat
    public var textViewBottomMarginToHintLabel: CGFloat

    public var clearButtonHeight: CGFloat
    public var clearButtonWidth: CGFloat
    public var clearButtonTrailingMargin: CGFloat

    public var hintLabelLeadingMargin: CGFloat
    public var hintLabelTrailingMargin: CGFloat
    public var hintLabelMinHeight: CGFloat?
    public var hintLabelHeight: CGFloat?

    // MARK: Public Static Methods

    public static let `default` = TextViewLayoutServiceDefaultConstants(textViewTopMargin: 20,
                                                                        textViewLeadingMargin: 16,
                                                                        textViewTrailingMargin: 16,
                                                                        textViewHeight: 20,
                                                                        textViewBottomMarginToHintLabel: 9,
                                                                        clearButtonHeight: 28,
                                                                        clearButtonWidth: 44,
                                                                        clearButtonTrailingMargin: 16,
                                                                        hintLabelLeadingMargin: 16,
                                                                        hintLabelTrailingMargin: 16,
                                                                        hintLabelMinHeight: 15,
                                                                        hintLabelHeight: nil)

    // MARK: - Initializaion

    public init(textViewTopMargin: CGFloat,
                textViewLeadingMargin: CGFloat,
                textViewTrailingMargin: CGFloat,
                textViewHeight: CGFloat,
                textViewBottomMarginToHintLabel: CGFloat,
                clearButtonHeight: CGFloat,
                clearButtonWidth: CGFloat,
                clearButtonTrailingMargin: CGFloat,
                hintLabelLeadingMargin: CGFloat,
                hintLabelTrailingMargin: CGFloat,
                hintLabelMinHeight: CGFloat?,
                hintLabelHeight: CGFloat?) {
        self.textViewTopMargin = textViewTopMargin
        self.textViewLeadingMargin = textViewLeadingMargin
        self.textViewTrailingMargin = textViewTrailingMargin
        self.textViewHeight = textViewHeight
        self.textViewBottomMarginToHintLabel = textViewBottomMarginToHintLabel

        self.clearButtonHeight = clearButtonHeight
        self.clearButtonWidth = clearButtonWidth
        self.clearButtonTrailingMargin = clearButtonTrailingMargin

        self.hintLabelLeadingMargin = hintLabelLeadingMargin
        self.hintLabelTrailingMargin = hintLabelTrailingMargin
        self.hintLabelMinHeight = hintLabelMinHeight
        self.hintLabelHeight = hintLabelHeight
    }

}
