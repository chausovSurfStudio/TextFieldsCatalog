//
//  GuidedTextField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 13/05/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

/// Protocols for manageable text field, which can switch responder or resign it
public protocol GuidedTextField: AnyObject {
    var havePreviousInput: Bool { get }
    var haveNextInput: Bool { get }

    func processReturnAction()
    func switchToPreviousInput()
    func switchToNextInput()
}
