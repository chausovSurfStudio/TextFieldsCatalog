//
//  ValidationPolicy.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 13/10/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

/// Allows you to manage validation behaviors after text field end editing
public enum ValidationPolicy {
    /// Validation always performs after text field end editing
    case always
    /// Validation performs if current text is not empty
    case notEmptyText
    /// Validation performs if user make some changes into the text
    /// (entered at least one character, set the text, or manually validat the field)
    case afterChanges
}
