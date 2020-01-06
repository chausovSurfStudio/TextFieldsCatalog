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

    // MARK: - Properties

    var containerState: FieldContainerState {
        switch self {
        case .normal:
            return .normal
        case .active:
            return .active
        case .disabled:
            return .disabled
        }
    }

}
