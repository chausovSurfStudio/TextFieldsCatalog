//
//  FieldContainerState.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

/// Possible textField/textView container states,
/// includes FieldState cases plus `error` state case
public enum FieldContainerState {
    /// field not in focus
    case normal
    /// state for active field
    case active
    /// state for disabled field
    case disabled
    /// state for text field in error state
    case error
}
