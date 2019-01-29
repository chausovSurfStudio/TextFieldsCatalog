//
//  CustomUnderlinedTextField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 25/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import TextFieldsCatalog

fileprivate enum CustomColor {
    enum Main {
        static let background = UIColor.white
        static let error = UIColor(hexString: "e2001a")
        static let gray = UIColor(hexString: "999999")
        static let black = UIColor(hexString: "262626")
        static let blue = UIColor(hexString: "00afd0")
    }
    enum ActionButton {
        static let normal = CustomColor.Main.gray
        static let pressed = CustomColor.Main.gray.withAlphaComponent(0.5)
    }
}

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
        configuration.line = LineConfiguration(insets: UIEdgeInsets(top: 62, left: 16, bottom: 0, right: 16),
                                               defaultHeight: 1,
                                               increasedHeight: 2,
                                               cornerRadius: 1,
                                               colors: ColorConfiguration(error: CustomColor.Main.error,
                                                                          normal: CustomColor.Main.gray.withAlphaComponent(0.5),
                                                                          active: CustomColor.Main.blue,
                                                                          disabled: CustomColor.Main.gray.withAlphaComponent(0.5)))
        configuration.placeholder = FloatingPlaceholderConfiguration(font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                                                     height: 24,
                                                                     topInsets: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16),
                                                                     bottomInsets: UIEdgeInsets(top: 21, left: 15, bottom: 0, right: 16),
                                                                     smallFontSize: 14,
                                                                     bigFontSize: 16,
                                                                     topColors: ColorConfiguration(error: CustomColor.Main.error,
                                                                                                   normal: CustomColor.Main.gray,
                                                                                                   active: CustomColor.Main.blue,
                                                                                                   disabled: CustomColor.Main.gray),
                                                                     bottomColors: ColorConfiguration(error: CustomColor.Main.gray,
                                                                                                      normal: CustomColor.Main.gray,
                                                                                                      active: CustomColor.Main.gray,
                                                                                                      disabled: CustomColor.Main.gray))
        configuration.textField = TextFieldConfiguration(font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                                         defaultPadding: UIEdgeInsets.zero,
                                                         increasedPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 36),
                                                         tintColor: CustomColor.Main.blue,
                                                         colors: ColorConfiguration(error: CustomColor.Main.black,
                                                                                    normal: CustomColor.Main.black,
                                                                                    active: CustomColor.Main.black,
                                                                                    disabled: CustomColor.Main.gray))
        configuration.passwordMode = PasswordModeConfiguration(secureModeOnImage: UIImage(asset: Asset.customEyeOn),
                                                               secureModeOffImage: UIImage(asset: Asset.customEyeOff),
                                                               normalColor: CustomColor.ActionButton.normal,
                                                               pressedColor: CustomColor.ActionButton.pressed)
        configuration.background = BackgroundConfiguration(color: CustomColor.Main.background)
        self.configuration = configuration
    }

}
