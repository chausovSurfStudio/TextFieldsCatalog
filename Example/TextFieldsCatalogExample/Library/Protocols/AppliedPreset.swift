//
//  AppliedPreset.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 24/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

/// Describes preset type which can be applied to the text field
protocol AppliedPreset {
    var name: String { get }
    var description: String { get }
    func apply(for field: Any, with heightConstraint: NSLayoutConstraint)
}
