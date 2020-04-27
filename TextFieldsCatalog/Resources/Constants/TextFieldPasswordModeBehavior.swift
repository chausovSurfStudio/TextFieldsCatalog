//
//  TextFieldPasswordModeBehavior.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 08/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

public enum TextFieldPasswordModeBehavior {
    /// password button always visible
    case alwaysVisible
    /// password button visible only if text is not empty
    case visibleOnNotEmptyText
    /// password button becomes visible after the user enters the first character,
    /// and never disappears again.
    case visibleAfterFirstEntry
}
