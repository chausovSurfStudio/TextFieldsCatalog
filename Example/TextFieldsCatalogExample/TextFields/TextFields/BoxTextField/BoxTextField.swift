//
//  BoxTextField.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit
import TextFieldsCatalog

/// Custom subclass for Underlined text field with border around text field.
/// Standart height equals 130.
final class BoxTextField: UnderlinedTextField {

    // MARK: - Subviews

    private let containerView = UIView()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
        configureContainer()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UIView

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
        configureContainer()
    }

    // MARK: - Internal Methods

    func configure(supportPlaceholder: String) {
        let config = NativePlaceholderConfiguration(font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                                    height: 24,
                                                    insets: UIEdgeInsets(top: 67, left: 32, bottom: 0, right: 32),
                                                    colors: ColorConfiguration(color: Color.UnderlineTextField.placeholder),
                                                    behavior: .hideOnFocus,
                                                    useAsMainPlaceholder: true,
                                                    increasedRightPadding: 32)
        let service = NativePlaceholderService(configuration: config)
        add(placeholderService: service)
        service.setup(placeholder: supportPlaceholder)
    }

}

// MARK: - Configure

private extension BoxTextField {

    func configureAppearance() {
        let configuration = UnderlinedTextFieldConfiguration()
        configuration.line = LineConfiguration(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                               defaultHeight: 1,
                                               increasedHeight: 1,
                                               cornerRadius: 0,
                                               superview: nil,
                                               colors: ColorConfiguration(color: UIColor.clear))
        configuration.textField = TextFieldConfiguration(font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                                         defaultPadding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16),
                                                         increasedPadding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 56),
                                                         tintColor: Color.UnderlineTextField.tint,
                                                         colors: ColorConfiguration(error: Color.UnderlineTextField.text,
                                                                                    normal: Color.UnderlineTextField.text,
                                                                                    active: Color.UnderlineTextField.text,
                                                                                    disabled: Color.UnderlineTextField.placeholder))
        configuration.passwordMode = PasswordModeConfiguration(secureModeOnImage: UIImage(asset: Asset.customEyeOn),
                                                               secureModeOffImage: UIImage(asset: Asset.customEyeOff),
                                                               normalColor: Color.UnderlineTextField.ActionButton.normal,
                                                               pressedColor: Color.UnderlineTextField.ActionButton.pressed)
        configuration.background = BackgroundConfiguration(color: Color.Main.background)
        self.configuration = configuration

        let placeholderConfig = StaticPlaceholderConfiguration(font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                                               height: 19,
                                                               insets: UIEdgeInsets(top: 13, left: 16, bottom: 0, right: 16),
                                                               colors: ColorConfiguration(color: Color.UnderlineTextField.placeholder))
        self.setup(placeholderServices: [StaticPlaceholderService(configuration: placeholderConfig)])
        self.setup(hintService: HintService(configuration: .init(font: UIFont.systemFont(ofSize: 13, weight: .regular),
                                                                 lineHeight: 17,
                                                                 colors: ColorConfiguration(error: Color.UnderlineTextField.error,
                                                                                            normal: Color.UnderlineTextField.placeholder,
                                                                                            active: Color.UnderlineTextField.placeholder,
                                                                                            disabled: Color.UnderlineTextField.placeholder)),
                                            visibleHintStates: .all))
        self.heightLayoutPolicy = .elastic(policy: .init(minHeight: 130,
                                                         bottomOffset: 5,
                                                         ignoreEmptyHint: false))
        self.validationPolicy = .always

        let layoutServiceConstants = TextFieldLayoutServiceDefaultConstants(textFieldTopMargin: 49,
                                                                            textFieldLeadingMargin: 16,
                                                                            textFieldTrailingMargin: 16,
                                                                            textFieldHeight: 60,
                                                                            textFieldBottomMarginToHintLabel: 6,
                                                                            actionButtonHeight: 56,
                                                                            actionButtonWidth: 44,
                                                                            actionButtonTrailingMargin: 16,
                                                                            hintLabelLeadingMargin: 16,
                                                                            hintLabelTrailingMargin: 16,
                                                                            hintLabelMinHeight: 16,
                                                                            hintLabelHeight: nil)
        self.setup(layoutService: TextFieldLayoutServiceDefault(constants: layoutServiceConstants))
    }

    func configureContainer() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.isUserInteractionEnabled = false
        containerView.backgroundColor = .clear
        containerView.layer.borderWidth = 2
        containerView.layer.cornerRadius = 6
        containerView.layer.borderColor = Color.UnderlineTextField.normal.cgColor
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 49),
            containerView.heightAnchor.constraint(equalToConstant: 60)
        ])

        onContainerStateChanged = { [weak self] state in
            self?.updateContainerBorder(for: state)
        }
    }

}

// MARK: - Private Methods

private extension BoxTextField {

    func updateContainerBorder(for state: FieldContainerState) {
        let color: UIColor
        switch state {
        case .error:
            color = Color.UnderlineTextField.error
        case .active:
            color = Color.UnderlineTextField.tint
        case .normal, .disabled:
            color = Color.UnderlineTextField.normal
        }
        containerView.layer.borderColor = color.cgColor
    }

}
