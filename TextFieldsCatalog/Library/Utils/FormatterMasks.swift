//
//  FormatterMasks.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 28/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation
import InputMask

/// Masks for text field formatters. Rules for this masks you can see in https://github.com/RedMadRobot/input-mask-ios
/// As additional notations for this masks you can use "s" character for all characters except newlines and whitespaces
public enum FormatterMasks {
    static let password = "[ssssssss][s…]"
    static let phone = "+7 ([000]) [000]-[00]-[00]"
    static let cardExpirationDate = "[00]/[00]"
    static let cvc = "[000]"
    static let cardNumber = "[0000] [0000] [0000] [0000] [999]"
}

// MARK: - Custom Notations

extension FormatterMasks {

    private enum Notations {
        enum ExcludeNewlinesAndWhitespaces {
            static let character: Character = "s"
            static let set = CharacterSet.whitespacesAndNewlines.inverted
        }
    }

    /// Method returns all custom notations for this application
    static func notations() -> [Notation] {
        return [
            Notation(character: FormatterMasks.Notations.ExcludeNewlinesAndWhitespaces.character,
                     characterSet: FormatterMasks.Notations.ExcludeNewlinesAndWhitespaces.set,
                     isOptional: false)
        ]
    }

}
