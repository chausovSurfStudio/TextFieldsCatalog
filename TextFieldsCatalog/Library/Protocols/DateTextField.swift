//
//  DateTextField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 12/05/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

/// Protocols for text field which can communicate with DatePickerView as its inputView
public protocol DateTextField: class {
    func processDateChange(_ date: Date, text: String)
}
