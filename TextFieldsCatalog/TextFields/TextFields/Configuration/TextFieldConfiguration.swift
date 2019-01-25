//
//  TextFieldConfiguration.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 25/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

final class UnderlinedTextFieldConfiguration {
    var line: LineConfiguration
    var placeholder: FloatingPlaceholderConfiguration
    var textField: TextFieldConfiguration
    var hint: HintConfiguration
    var passwordMode: PasswordModeConfiguration
    var background: BackgroundConfiguration

    init() {
        line = LineConfiguration(smallHeight: 1,
                                 bigHeight: 2,
                                 cornerRadius: 1,
                                 colors: ColorConfiguration(error: Color.Main.red,
                                                            normal: Color.Main.container,
                                                            active: Color.Main.active,
                                                            disabled: Color.Main.container))
        placeholder = FloatingPlaceholderConfiguration(font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                                       topPosition: CGRect(x: 16, y: 2, width: 288, height: 19),
                                                       bottomPosition: CGRect(x: 15, y: 23, width: 288, height: 19),
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

final class BorderedTextFieldConfiguration {
//    let placeholder: PlaceholderConfiguration
//    let textField: TextFieldConfiguration
//    let textFieldBorder: TextFieldBorderConfiguration
//    let hint: HintConfiguration
//    let passwordMode: PasswordModeConfiguration
//    let background: BackgroundConfiguration
//
//    init() {
//        placeholder = PlaceholderConfiguration()
//        textField = TextFieldConfiguration()
//        textFieldBorder = TextFieldBorderConfiguration()
//        hint = HintConfiguration()
//        passwordMode = PasswordModeConfiguration()
//        background = BackgroundConfiguration()
//    }
}

final class LineConfiguration {
    let smallHeight: CGFloat
    let bigHeight: CGFloat
    let cornerRadius: CGFloat
    let colors: ColorConfiguration

    init(smallHeight: CGFloat,
         bigHeight: CGFloat,
         cornerRadius: CGFloat,
         colors: ColorConfiguration) {
        self.smallHeight = smallHeight
        self.bigHeight = bigHeight
        self.cornerRadius = cornerRadius
        self.colors = colors
    }
}

final class FloatingPlaceholderConfiguration {
    let font: UIFont
    let topPosition: CGRect
    let bottomPosition: CGRect
    let smallFontSize: CGFloat
    let bigFontSize: CGFloat
    let topColors: ColorConfiguration
    let bottomColors: ColorConfiguration

    init(font: UIFont,
         topPosition: CGRect,
         bottomPosition: CGRect,
         smallFontSize: CGFloat,
         bigFontSize: CGFloat,
         topColors: ColorConfiguration,
         bottomColors: ColorConfiguration) {
        self.font = font
        self.topPosition = topPosition
        self.bottomPosition = bottomPosition
        self.smallFontSize = smallFontSize
        self.bigFontSize = bigFontSize
        self.topColors = topColors
        self.bottomColors = bottomColors
    }
}

final class PlaceholderConfiguration {

}

final class TextFieldConfiguration {
    let font: UIFont
    let defaultPadding: UIEdgeInsets
    let increasedPadding: UIEdgeInsets
    let tintColor: UIColor
    let colors: ColorConfiguration

    init(font: UIFont,
         defaultPadding: UIEdgeInsets,
         increasedPadding: UIEdgeInsets,
         tintColor: UIColor,
         colors: ColorConfiguration) {
        self.font = font
        self.defaultPadding = defaultPadding
        self.increasedPadding = increasedPadding
        self.tintColor = tintColor
        self.colors = colors
    }
}

final class TextFieldBorderConfiguration {

}

final class HintConfiguration {
    let font: UIFont
    let colors: ColorConfiguration

    init(font: UIFont, colors: ColorConfiguration) {
        self.font = font
        self.colors = colors
    }
}

final class PasswordModeConfiguration {
    let secureModeOnImage: UIImage
    let secureModeOffImage: UIImage
    let normalColor: UIColor
    let pressedColor: UIColor

    init(secureModeOnImage: UIImage,
         secureModeOffImage: UIImage,
         normalColor: UIColor,
         pressedColor: UIColor) {
        self.secureModeOnImage = secureModeOnImage
        self.secureModeOffImage = secureModeOffImage
        self.normalColor = normalColor
        self.pressedColor = pressedColor
    }
}

final class BackgroundConfiguration {
    let color: UIColor

    init(color: UIColor) {
        self.color = color
    }
}

final class ColorConfiguration {
    let error: UIColor
    let normal: UIColor
    let active: UIColor
    let disabled: UIColor

    init(error: UIColor, normal: UIColor, active: UIColor, disabled: UIColor) {
        self.error = error
        self.normal = normal
        self.active = active
        self.disabled = disabled
    }
}
