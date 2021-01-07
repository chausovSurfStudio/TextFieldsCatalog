//
//  Character.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 07.01.2021.
//  Copyright © 2021 Александр Чаусов. All rights reserved.
//

extension Character {

    /**
     Returns true, if character is emoji, false in other case

     Warning: works only for ios higher than 10.2, for lower versions always returns false
     */
    var isEmoji: Bool {
        if #available(iOS 10.2, *) {
            let containsSpecificSymbols = unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector }
            let containsEmojiOrOtherSymbol = unicodeScalars.allSatisfy {
                $0.properties.isEmojiPresentation ||
                $0.properties.generalCategory == .otherSymbol
            }
            // 🏴󠁧󠁢󠁥󠁮󠁧󠁿, 🏴󠁧󠁢󠁳󠁣󠁴󠁿, 🏴󠁧󠁢󠁷󠁬󠁳󠁿
            let isOtherEmoji = unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false
            return [
                containsSpecificSymbols,
                containsEmojiOrOtherSymbol,
                isOtherEmoji
            ].contains(true)
        } else {
            return false
        }
    }

}
