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
/// Standart height equals 102.
final class SumTextField: UnderlinedTextField {

    // MARK: - Private Properties

    private var supportPlaceholderService: AbstractPlaceholderService?
    private var lastValidValue: String = ""

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

    func configure(currencyPlaceholder: String) {
        let service = CurrencyPlaceholderService(insets: UIEdgeInsets(top: 37, left: 10, bottom: 0, right: 16),
                                                 height: 54,
                                                 font: UIFont.systemFont(ofSize: 50, weight: .regular),
                                                 color: Color.UnderlineTextField.placeholder)
        add(placeholderService: service)
        service.setup(placeholder: currencyPlaceholder)
    }

    func configureForSum() {
        self.onTextChanged = { [weak self] field in
            guard !field.text.isEmpty else {
                self?.lastValidValue = ""
                return
            }
            guard let sum = self?.formatPrice(field.text) else {
                field.setup(text: self?.lastValidValue)
                return
            }
            self?.lastValidValue = sum
            field.text = sum
        }
        self.onEndEditing = { [weak self] field in
            let text = field.text
            guard
                !text.isEmpty,
                let sum = self?.finalFormatPrice(text)
            else {
                return
            }
            self?.lastValidValue = sum
            self?.configure(supportPlaceholder: sum + "\u{2009}₽")
            field.text = sum
        }
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
        self.setup(hintService: HintService(configuration: .init(font: UIFont.systemFont(ofSize: 13, weight: .regular),
                                                                 lineHeight: 17,
                                                                 colors: ColorConfiguration(error: Color.UnderlineTextField.error,
                                                                                            normal: Color.UnderlineTextField.placeholder,
                                                                                            active: Color.UnderlineTextField.placeholder,
                                                                                            disabled: Color.UnderlineTextField.placeholder))))
        self.heightLayoutPolicy = .elastic(minHeight: 102, bottomSpace: 5, ignoreEmptyHint: true)
        self.validationPolicy = .afterChanges
    }

}

// MARK: - Private Methods

private extension SumTextField {

    // MARK: - Private Properties

    private static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "\u{2009}"
        formatter.locale = Locale(identifier: "RU_ru")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    // MARK: - Methods

    func formatPrice(_ price: String?) -> String? {
        guard let string = price else {
            return nil
        }
        let clearString = string.replacingOccurrences(of: "\u{2009}", with: "")
        let groups = clearString.split(separator: ",")

        guard groups.count <= 2 && clearString.filter({ $0 == "," }).count <= 1 else {
            // if string have more than one `,` character
            return nil
        }
        guard clearString != "," else {
            // if string is equal to `,` - replace it on `0,`
            return "0,"
        }
        guard clearString.suffix(1) != "," else {
            // if user enter `,` in end of the string - allow it to him
            return string
        }

        guard (groups.first?.count ?? 0) <= 9 else {
            // returns nil if integer part have more than 9 character
            return nil
        }
        if groups.count == 2 {
            if groups[1].count == 3 {
                // if user enter third character in decimal part
                return String(string.dropLast())
            } else {
                SumTextField.priceFormatter.minimumFractionDigits = groups[1].count
            }
        } else {
            SumTextField.priceFormatter.minimumFractionDigits = 0
        }

        guard let number = SumTextField.priceFormatter.number(from: clearString) else {
            return nil
        }
        return SumTextField.priceFormatter.string(for: number)
    }

    func finalFormatPrice(_ price: String?) -> String? {
        guard let string = price else {
            return nil
        }

        let clearString = string.replacingOccurrences(of: "\u{2009}", with: "")
        let groups = clearString.split(separator: ",")
        SumTextField.priceFormatter.minimumFractionDigits = groups.count > 1 ? 2 : 0

        guard let number = SumTextField.priceFormatter.number(from: clearString) else {
            return nil
        }
        return SumTextField.priceFormatter.string(for: number)?.replacingOccurrences(of: ",00", with: "")
    }

}
