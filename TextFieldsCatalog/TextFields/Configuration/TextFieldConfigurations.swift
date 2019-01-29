//
//  TextFieldConfigurations.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 28/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

public final class BorderedTextFieldConfiguration {
    public var placeholder: PlaceholderConfiguration
    public var textField: TextFieldConfiguration
    public var textFieldBorder: TextFieldBorderConfiguration
    public var hint: HintConfiguration
    public var passwordMode: PasswordModeConfiguration
    public var background: BackgroundConfiguration

    public init() {
        placeholder = PlaceholderConfiguration(font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                               colors: ColorConfiguration(error: Color.Text.gray,
                                                                          normal: Color.Text.gray,
                                                                          active: Color.Text.gray,
                                                                          disabled: Color.Text.gray))
        textField = TextFieldConfiguration(font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                           defaultPadding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16),
                                           increasedPadding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 56),
                                           tintColor: Color.Main.active,
                                           colors: ColorConfiguration(error: Color.Text.white,
                                                                      normal: Color.Text.white,
                                                                      active: Color.Text.white,
                                                                      disabled: Color.Text.white))
        textFieldBorder = TextFieldBorderConfiguration(cornerRadius: 6,
                                                       width: 2,
                                                       colors: ColorConfiguration(error: Color.Main.red,
                                                                                  normal: Color.Main.container,
                                                                                  active: Color.Main.active,
                                                                                  disabled: Color.Main.container))
        hint = HintConfiguration(font: UIFont.systemFont(ofSize: 13, weight: .regular),
                                 colors: ColorConfiguration(error: Color.Text.red,
                                                            normal: Color.Text.gray,
                                                            active: Color.Text.gray,
                                                            disabled: Color.Text.gray))
        passwordMode = PasswordModeConfiguration(secureModeOnImage: UIImage(asset: Asset.eyeOn),
                                                 secureModeOffImage: UIImage(asset: Asset.eyeOff),
                                                 normalColor: Color.Button.active,
                                                 pressedColor: Color.Button.pressed)
        background = BackgroundConfiguration(color: Color.Main.background)
    }
}

public final class UnderlinedTextFieldConfiguration {
    public var line: LineConfiguration
    public var placeholder: FloatingPlaceholderConfiguration
    public var textField: TextFieldConfiguration
    public var hint: HintConfiguration
    public var passwordMode: PasswordModeConfiguration
    public var background: BackgroundConfiguration

    public init() {
        line = LineConfiguration(insets: UIEdgeInsets(top: 53, left: 16, bottom: 0, right: 16),
                                 defaultHeight: 1,
                                 increasedHeight: 2,
                                 cornerRadius: 1,
                                 colors: ColorConfiguration(error: Color.Main.red,
                                                            normal: Color.Main.container,
                                                            active: Color.Main.active,
                                                            disabled: Color.Main.container))
        placeholder = FloatingPlaceholderConfiguration(font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                                       height: 19,
                                                       topInsets: UIEdgeInsets(top: 2, left: 16, bottom: 0, right: 16),
                                                       bottomInsets: UIEdgeInsets(top: 23, left: 15, bottom: 0, right: 16),
                                                       smallFontSize: 12,
                                                       bigFontSize: 16,
                                                       topColors: ColorConfiguration(error: Color.Text.gray,
                                                                                     normal: Color.Text.gray,
                                                                                     active: Color.Text.active,
                                                                                     disabled: Color.Text.gray),
                                                       bottomColors: ColorConfiguration(error: Color.Text.white,
                                                                                        normal: Color.Text.white,
                                                                                        active: Color.Text.active,
                                                                                        disabled: Color.Text.gray))
        textField = TextFieldConfiguration(font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                           defaultPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                           increasedPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40),
                                           tintColor: Color.Text.active,
                                           colors: ColorConfiguration(error: Color.Text.white,
                                                                      normal: Color.Text.white,
                                                                      active: Color.Text.white,
                                                                      disabled: Color.Text.gray))
        hint = HintConfiguration(font: UIFont.systemFont(ofSize: 12, weight: .regular),
                                 colors: ColorConfiguration(error: Color.Main.red,
                                                            normal: Color.Text.gray,
                                                            active: Color.Text.gray,
                                                            disabled: Color.Text.gray))
        passwordMode = PasswordModeConfiguration(secureModeOnImage: UIImage(asset: Asset.eyeOn),
                                                 secureModeOffImage: UIImage(asset: Asset.eyeOff),
                                                 normalColor: Color.Button.active,
                                                 pressedColor: Color.Button.pressed)
        background = BackgroundConfiguration(color: Color.Main.background)
    }
}
