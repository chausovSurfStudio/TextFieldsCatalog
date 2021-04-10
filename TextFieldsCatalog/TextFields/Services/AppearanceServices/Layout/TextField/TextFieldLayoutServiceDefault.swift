//
//  TextFieldLayoutServiceDefault.swift
//  TextFieldsCatalog
//
//  Created by al.filimonov on 10.04.2021.
//

import Foundation

/// Default implementation of service for layouting textField
public class TextFieldLayoutServiceDefault: TextFieldLayoutServiceAbstract {

    // MARK: - Private Properties

    private let constants: TextFieldLayoutServiceDefaultConstants

    // MARK: - Initializaion

    public init(constants: TextFieldLayoutServiceDefaultConstants) {
        self.constants = constants
    }

    // MARK: - TextFieldLayoutServiceAbstract

    public func layout(textField: InnerTextField,
                       hintLabel: UILabel,
                       actionButton: UIButton,
                       in superview: UIView) {
        // remove from superview and remove constraints
        let views = [textField, hintLabel, actionButton]
        views.forEach {
            $0.removeFromSuperview()
            $0.removeConstraints(textField.constraints)
        }

        // layout textField
        textField.apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            superview.addSubview($0)

            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: superview.leadingAnchor,
                                            constant: constants.textFieldLeadingMargin),
                $0.trailingAnchor.constraint(equalTo: superview.trailingAnchor,
                                             constant: -constants.textFieldTrailingMargin),
                $0.topAnchor.constraint(equalTo: superview.topAnchor,
                                        constant: constants.textFieldTopMargin),
                $0.heightAnchor.constraint(equalToConstant: constants.textFieldHeight),
            ])
        }

        // layout actionButton
        actionButton.apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            superview.addSubview($0)

            NSLayoutConstraint.activate([
                $0.trailingAnchor.constraint(equalTo: superview.trailingAnchor,
                                             constant: -constants.actionButtonTrailingMargin),
                $0.heightAnchor.constraint(equalToConstant: constants.actionButtonHeight),
                $0.widthAnchor.constraint(equalToConstant: constants.actionButtonWidth),
                $0.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
            ])
        }

        // layout hintLabel
        hintLabel.apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            superview.addSubview($0)

            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: superview.leadingAnchor,
                                            constant: constants.hintLabelLeadingMargin),
                $0.trailingAnchor.constraint(equalTo: superview.trailingAnchor,
                                             constant: -constants.hintLabelTrailingMargin),
                $0.topAnchor.constraint(equalTo: textField.bottomAnchor,
                                        constant: constants.textFieldBottomMarginToHintLabel)
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
    }

}
