//
//  FieldState.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 05/09/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

/// Possible textField/textView states
enum FieldState {
    /// field not in focus
    case normal
    /// state for active field
    case active
    /// state for disabled field
    case disabled
}
