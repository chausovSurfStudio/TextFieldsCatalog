//
//  NativePlaceholderBehavior.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 28/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

public enum NativePlaceholderBehavior {
    /// placeholder will hide when user tap on the field,
    /// recommend to use with 'useAsMainPlaceholder' == true case
    case hideOnFocus
    /// placeholder will hide when user enter at least one character in field
    case hideOnInput
}
