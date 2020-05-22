//
//  RespondableField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 22/05/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

public protocol RespondableField {
    var nextInput: UIResponder? { get set }
    var previousInput: UIResponder? { get set }
    var isFirstResponder: Bool { get }

    func becomeFirstResponder() -> Bool
}
