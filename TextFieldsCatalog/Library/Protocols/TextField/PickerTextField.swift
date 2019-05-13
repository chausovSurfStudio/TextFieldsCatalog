//
//  PickerTextField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 13/05/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

/// Protocols for text field which can communicate with PlainPickerView as its inputView
public protocol PickerTextField: GuidedTextField {
    func processValueChange(_ value: String)
}
