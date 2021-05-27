//
//  FormatterMasks.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 27/05/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation
import TextFieldsCatalog
import InputMask

extension FormatterMasks {

    static let name = "[R…]"

    private enum Notations {
        enum RussianSymbolsAndSpaces {
            static let character: Character = "R"
            static let set = CharacterSet(charactersIn: "абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ ")
        }
    }

    /// Method returns all custom notations for this application
    static func customNotations() -> [Notation] {
        return [
            Notation(character: FormatterMasks.Notations.RussianSymbolsAndSpaces.character,
                     characterSet: FormatterMasks.Notations.RussianSymbolsAndSpaces.set,
                     isOptional: false)
        ]
    }

}
