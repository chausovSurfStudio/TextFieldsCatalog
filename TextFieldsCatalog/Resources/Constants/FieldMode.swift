//
//  FieldMode.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 05/09/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

/// Possible mode for textFields
public enum TextFieldMode {
    /// normal textField mode without any action buttons
    case plain
    /// mode for password textField
    case password
    /// mode for textField with custom action button
    case custom(ActionButtonConfiguration)
}
