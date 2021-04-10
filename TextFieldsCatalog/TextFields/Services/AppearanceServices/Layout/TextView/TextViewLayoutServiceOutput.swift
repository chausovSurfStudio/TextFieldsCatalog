//
//  TextViewLayoutServiceOutput.swift
//  TextFieldsCatalog
//
//  Created by al.filimonov on 10.04.2021.
//

import Foundation

/// Output of service for layouting textView
public struct TextViewLayoutServiceOutput {

    // MARK: - Public Properties

    public let textViewHeightConstraint: NSLayoutConstraint
    public let textViewTopConstraint: NSLayoutConstraint
    public let textViewBottomConstraint: NSLayoutConstraint

    // MARK: - Initialization

    public init(textViewHeightConstraint: NSLayoutConstraint,
                textViewTopConstraint: NSLayoutConstraint,
                textViewBottomConstraint: NSLayoutConstraint) {
        self.textViewHeightConstraint = textViewHeightConstraint
        self.textViewTopConstraint = textViewTopConstraint
        self.textViewBottomConstraint = textViewBottomConstraint
    }

}
