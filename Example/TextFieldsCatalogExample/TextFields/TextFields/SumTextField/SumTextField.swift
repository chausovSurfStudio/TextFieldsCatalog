//
//  SumTextField.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 19/05/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit
import TextFieldsCatalog

/// Custom subclass for Underlined text field.
/// Standart height equals 112.
final class SumTextField: UnderlinedTextField {

    // MARK: - Private Properties

    private var supportPlaceholderService: AbstractPlaceholderService?

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

    // MARK: - Internal Methods

    func configure(supportPlaceholder: String) {
        supportPlaceholderService?.setup(placeholder: supportPlaceholder)
    }

}

// MARK: - Configure

private extension SumTextField {

    func configureAppearance() {
        let configuration = UnderlinedTextFieldConfiguration()
        configuration.line = LineConfiguration(insets: UIEdgeInsets(top: 9, left: 16, bottom: 0, right: 16),
                                               defaultHeight: 1,
                                               increasedHeight: 2,
                                               cornerRadius: 1,
                                               superview: nil,
                                               colors: ColorConfiguration(error: Color.UnderlineTextField.error,
                                                                          normal: Color.UnderlineTextField.placeholder.withAlphaComponent(0.5),
                                                                          active: Color.UnderlineTextField.tint,
                                                                          disabled: Color.UnderlineTextField.placeholder.withAlphaComponent(0.5)))
        configuration.textField = TextFieldConfiguration(font: UIFont.systemFont(ofSize: 50, weight: .regular),
                                                         defaultPadding: UIEdgeInsets.zero,
                                                         increasedPadding: UIEdgeInsets.zero,
                                                         tintColor: Color.UnderlineTextField.tint,
                                                         colors: ColorConfiguration(error: Color.UnderlineTextField.text,
                                                                                    normal: Color.UnderlineTextField.text,
                                                                                    active: Color.UnderlineTextField.text,
                                                                                    disabled: Color.UnderlineTextField.placeholder))
        configuration.hint = HintConfiguration(font: UIFont.systemFont(ofSize: 13, weight: .regular),
                                               lineHeight: 17,
                                               colors: ColorConfiguration(error: Color.UnderlineTextField.error,
                                                                          normal: Color.UnderlineTextField.placeholder,
                                                                          active: Color.UnderlineTextField.placeholder,
                                                                          disabled: Color.UnderlineTextField.placeholder))
        configuration.background = BackgroundConfiguration(color: Color.Main.background)
        self.configuration = configuration

        let staticPlaceholderConfig = StaticPlaceholderConfiguration(font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                                                     height: 20,
                                                                     insets: UIEdgeInsets(top: 3, left: 16, bottom: 0, right: 16),
                                                                     colors: ColorConfiguration(color: Color.UnderlineTextField.placeholder))
        let supportPlaceholderConfig = NativePlaceholderConfiguration(font: UIFont.systemFont(ofSize: 50, weight: .regular),
                                                                      height: 54,
                                                                      insets: UIEdgeInsets(top: 37, left: 16, bottom: 0, right: 16),
                                                                      colors: ColorConfiguration(color: Color.UnderlineTextField.placeholder),
                                                                      behavior: .hideOnInput,
                                                                      useAsMainPlaceholder: true,
                                                                      increasedRightPadding: 16)
        let supportPlaceholderService = NativePlaceholderService(configuration: supportPlaceholderConfig)
        self.supportPlaceholderService = supportPlaceholderService
        self.setup(placeholderServices: [StaticPlaceholderService(configuration: staticPlaceholderConfig),
                                         supportPlaceholderService])

        self.heightLayoutPolicy = .flexible(112, 5)
        self.validationPolicy = .afterChanges
        self.textVerticalAlignment = .bottom
    }

}
