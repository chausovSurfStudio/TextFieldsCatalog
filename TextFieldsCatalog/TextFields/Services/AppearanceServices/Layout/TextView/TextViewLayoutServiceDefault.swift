//
//  TextViewLayoutServiceDefault.swift
//  TextFieldsCatalog
//
//  Created by al.filimonov on 10.04.2021.
//

import Foundation

/// Default implementation of service for layouting textView
public class TextViewLayoutServiceDefault: TextViewLayoutServiceAbstract {

    // MARK: - Private Properties

    private let constants: TextViewLayoutServiceDefaultConstants

    // MARK: - Initializaion

    public init(constants: TextViewLayoutServiceDefaultConstants) {
        self.constants = constants
    }

    // MARK: - TextViewLayoutServiceAbstract

    public func layout(textView: UITextView,
                       hintLabel: UILabel,
                       clearButton: UIButton,
                       in superview: UIView) -> TextViewLayoutServiceOutput {
        // remove from superview and remove constraints
        let views = [textView, hintLabel, clearButton]
        views.forEach {
            $0.removeFromSuperview()
            $0.removeConstraints(textView.constraints)
        }

        // layout hintLabel
        hintLabel.apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            superview.addSubview($0)

            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constants.hintLabelLeadingMargin),
                $0.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constants.hintLabelTrailingMargin)
            ])
            if let hintLabelHeight = constants.hintLabelHeight {
                NSLayoutConstraint.activate([
                    $0.heightAnchor.constraint(equalToConstant: hintLabelHeight)
                ])
            }
            if let hintLabelMinHeight = constants.hintLabelMinHeight {
                NSLayoutConstraint.activate([
                    $0.heightAnchor.constraint(greaterThanOrEqualToConstant: hintLabelMinHeight)
                ])
            }
        }

        // layout textField
        var textViewHeightConstraint: NSLayoutConstraint!
        var textViewTopConstraint: NSLayoutConstraint!
        var textViewBottomConstraint: NSLayoutConstraint!
        textView.apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            superview.addSubview($0)

            textViewHeightConstraint = $0.heightAnchor.constraint(equalToConstant: constants.textViewHeight)
            textViewTopConstraint = $0.topAnchor.constraint(equalTo: superview.topAnchor,
                                                            constant: constants.textViewTopMargin)
            textViewBottomConstraint = $0.bottomAnchor.constraint(equalTo: hintLabel.topAnchor,
                                                                  constant: -constants.textViewBottomMarginToHintLabel)
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constants.textViewLeadingMargin),
                $0.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constants.textViewTrailingMargin),
                textViewTopConstraint,
                textViewHeightConstraint,
                textViewBottomConstraint
            ])
        }

        // layout actionButton
        clearButton.apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            superview.addSubview($0)

            NSLayoutConstraint.activate([
                $0.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constants.clearButtonTrailingMargin),
                $0.heightAnchor.constraint(equalToConstant: constants.clearButtonHeight),
                $0.widthAnchor.constraint(equalToConstant: constants.clearButtonWidth),
                $0.centerYAnchor.constraint(equalTo: textView.centerYAnchor)
            ])
        }

        return .init(textViewHeightConstraint: textViewHeightConstraint,
                     textViewTopConstraint: textViewTopConstraint,
                     textViewBottomConstraint: textViewBottomConstraint)
    }

}
