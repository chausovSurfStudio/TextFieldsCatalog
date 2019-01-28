//
//  ResetableField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 28/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

/// Describes type of field which can reset its state
protocol ResetableField {
    func reset()
}
