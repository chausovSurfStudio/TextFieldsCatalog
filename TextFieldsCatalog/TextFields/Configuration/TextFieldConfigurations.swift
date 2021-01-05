//
//  TextFieldConfigurations.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 28/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

public class BaseFieldConfiguration {

    // MARK: - Public Properties

    public var textField: TextFieldConfiguration
    public var line: LineConfiguration
    public var background: BackgroundConfiguration

    // MARK: - Initialization

    init(textField: TextFieldConfiguration,
         line: LineConfiguration,
         background: BackgroundConfiguration) {
        self.textField = textField
        self.line = line
        self.background = background
    }

}

public final class UnderlinedTextFieldConfiguration: BaseFieldConfiguration {

    // MARK: - Public Properties

    public var passwordMode: PasswordModeConfiguration

    // MARK: - Initialization

    public init() {
        let line = LineConfiguration(insets: UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16),
                                     defaultHeight: 1,
                                     increasedHeight: 2,
                                     cornerRadius: 1,
                                     superview: nil,
                                     colors: ColorConfiguration(error: Color.Main.red,
                                                                normal: Color.Main.container,
                                                                active: Color.Main.active,
                                                                disabled: Color.Main.container))
        let textField = TextFieldConfiguration(font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                               defaultPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                               increasedPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40),
                                               tintColor: Color.Text.active,
                                               colors: ColorConfiguration(error: Color.Text.white,
                                                                          normal: Color.Text.white,
                                                                          active: Color.Text.white,
                                                                          disabled: Color.Text.gray))
        let background = BackgroundConfiguration(color: Color.Main.background)

        passwordMode = PasswordModeConfiguration(secureModeOnImage: AssetManager().getImage("eyeOn"),
                                                 secureModeOffImage: AssetManager().getImage("eyeOff"),
                                                 normalColor: Color.Button.active,
                                                 pressedColor: Color.Button.pressed)
        super.init(textField: textField,
                   line: line,
                   background: background)
    }

}

public final class UnderlinedTextViewConfiguration: BaseFieldConfiguration {

    // MARK: - Public Properties

    public var clearButton: ActionButtonConfiguration

    // MARK: - Initialization

    public init() {
        let line = LineConfiguration(insets: UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 16),
                                     defaultHeight: 1,
                                     increasedHeight: 2,
                                     cornerRadius: 1,
                                     superview: nil,
                                     colors: ColorConfiguration(error: Color.Main.red,
                                                                normal: Color.Main.container,
                                                                active: Color.Main.active,
                                                                disabled: Color.Main.container))
        let textField = TextFieldConfiguration(font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                               defaultPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                               increasedPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40),
                                               tintColor: Color.Text.active,
                                               colors: ColorConfiguration(error: Color.Text.white,
                                                                          normal: Color.Text.white,
                                                                          active: Color.Text.white,
                                                                          disabled: Color.Text.gray))
        let background = BackgroundConfiguration(color: Color.Main.background)

        clearButton = ActionButtonConfiguration(image: AssetManager().getImage("close"),
                                                normalColor: Color.Button.active,
                                                pressedColor: Color.Button.pressed)
        super.init(textField: textField,
                   line: line,
                   background: background)
    }

}

extension FloatingPlaceholderConfiguration {

    static var defaultForTextField: FloatingPlaceholderConfiguration {
        return FloatingPlaceholderConfiguration.default(topRightPadding: 16)
    }

    static var defaultForTextView: FloatingPlaceholderConfiguration {
        return FloatingPlaceholderConfiguration.default(topRightPadding: 50)
    }

    static func `default`(topRightPadding: CGFloat) -> FloatingPlaceholderConfiguration {
        return FloatingPlaceholderConfiguration(font: UIFont.systemFont(ofSize: 16, weight: .regular),
                                                height: 19,
                                                topInsets: UIEdgeInsets(top: 2, left: 16, bottom: 0, right: topRightPadding),
                                                bottomInsets: UIEdgeInsets(top: 23, left: 15, bottom: 0, right: 16),
                                                increasedRightPadding: 70,
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
    }

}

extension HintConfiguration {

    static var `default`: HintConfiguration {
        return HintConfiguration(font: UIFont.systemFont(ofSize: 12, weight: .regular),
                                 lineHeight: 16,
                                 colors: ColorConfiguration(error: Color.Main.red,
                                                            normal: Color.Text.gray,
                                                            active: Color.Text.gray,
                                                            disabled: Color.Text.gray))
    }

}
