//
//  TextFieldLayoutServiceDefaultConstants.swift
//  TextFieldsCatalog
//
//  Created by al.filimonov on 10.04.2021.
//

import Foundation

public struct TextFieldLayoutServiceDefaultConstants {

    // MARK: - Public Properties

    public var textFieldTopMargin: CGFloat
    public var textFieldLeadingMargin: CGFloat
    public var textFieldTrailingMargin: CGFloat
    public var textFieldHeight: CGFloat
    public var textFieldBottomMarginToHintLabel: CGFloat

    public var actionButtonHeight: CGFloat
    public var actionButtonWidth: CGFloat
    public var actionButtonTrailingMargin: CGFloat

    public var hintLabelLeadingMargin: CGFloat
    public var hintLabelTrailingMargin: CGFloat
    public var hintLabelMinHeight: CGFloat?
    public var hintLabelHeight: CGFloat?

    // MARK: Public Static Methods

    public static let `default` = TextFieldLayoutServiceDefaultConstants(textFieldTopMargin: 18,
                                                                         textFieldLeadingMargin: 16,
                                                                         textFieldTrailingMargin: 16,
                                                                         textFieldHeight: 30,
                                                                         textFieldBottomMarginToHintLabel: 9,
                                                                         actionButtonHeight: 44,
                                                                         actionButtonWidth: 44,
                                                                         actionButtonTrailingMargin: 16,
                                                                         hintLabelLeadingMargin: 16,
                                                                         hintLabelTrailingMargin: 16,
                                                                         hintLabelMinHeight: 15,
                                                                         hintLabelHeight: nil)

    // MARK: - Initializaion

    public init(textFieldTopMargin: CGFloat,
                textFieldLeadingMargin: CGFloat,
                textFieldTrailingMargin: CGFloat,
                textFieldHeight: CGFloat,
                textFieldBottomMarginToHintLabel: CGFloat,
                actionButtonHeight: CGFloat,
                actionButtonWidth: CGFloat,
                actionButtonTrailingMargin: CGFloat,
                hintLabelLeadingMargin: CGFloat,
                hintLabelTrailingMargin: CGFloat,
                hintLabelMinHeight: CGFloat?,
                hintLabelHeight: CGFloat?) {
        self.textFieldTopMargin = textFieldTopMargin
        self.textFieldLeadingMargin = textFieldLeadingMargin
        self.textFieldTrailingMargin = textFieldTrailingMargin
        self.textFieldHeight = textFieldHeight
        self.textFieldBottomMarginToHintLabel = textFieldBottomMarginToHintLabel

        self.actionButtonHeight = actionButtonHeight
        self.actionButtonWidth = actionButtonWidth
        self.actionButtonTrailingMargin = actionButtonTrailingMargin

        self.hintLabelLeadingMargin = hintLabelLeadingMargin
        self.hintLabelTrailingMargin = hintLabelTrailingMargin
        self.hintLabelMinHeight = hintLabelMinHeight
        self.hintLabelHeight = hintLabelHeight
    }

}
