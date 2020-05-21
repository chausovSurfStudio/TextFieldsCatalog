//
//  CustomUnderlinedTextField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 25/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import TextFieldsCatalog

/// Custom subclass for Underlined text field.
/// Standart height equals 64.
final class CustomUnderlinedTextField: UnderlinedTextField {

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UIView

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

}

// MARK: - Configure

private extension CustomUnderlinedTextField {

    func configureAppearance() {
        let configuration = UnderlinedTextFieldConfiguration()
        configuration.line = LineConfiguration(insets: UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16),
                                               defaultHeight: 1,
                                               increasedHeight: 2,
                                               cornerRadius: 1,
                                               superview: nil,
                                               colors: ColorConfiguration(error: Color.UnderlineTextField.error,
                                                                          normal: Color.UnderlineTextField.placeholder.withAlphaComponent(0.5),
                                                                          active: Color.UnderlineTextField.tint,
                                                                          disabled: Color.UnderlineTextField.placeholder.withAlphaComponent(0.5)))
        configuration.textField = TextFieldConfiguration(font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                                         defaultPadding: UIEdgeInsets.zero,
                                                         increasedPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 36),
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

        let placeholderConfig = NativePlaceholderConfiguration(font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                                               height: 24,
                                                               insets: UIEdgeInsets(top: 30, left: 16, bottom: 0, right: 16),
                                                               colors: ColorConfiguration(error: Color.UnderlineTextField.error,
                                                                                          normal: Color.UnderlineTextField.normal,
                                                                                          active: Color.UnderlineTextField.tint,
                                                                                          disabled: Color.UnderlineTextField.placeholder),
                                                               behavior: .hideOnInput,
                                                               useAsMainPlaceholder: true,
                                                               increasedRightPadding: 60)
        self.setup(placeholderServices: [NativePlaceholderService(configuration: placeholderConfig)])

        self.validationPolicy = .afterChanges
    }

}
