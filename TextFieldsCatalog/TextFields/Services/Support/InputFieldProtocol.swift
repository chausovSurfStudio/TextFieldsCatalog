//
//  InputFieldProtocol.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 07/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit

/**
 Abstraction under UITextField/InnerTextField and UITextView

 The need is due to the desire to close two different classes with one protocol for use in places where both classes will be used in the same way.

 - Important: Protocol have two default extension with implementation for InnerTextField and UITextView.
 */
public protocol InputField: UIView {
    /// Text in textField/textView
    var inputText: String? { get }
    var textColor: UIColor? { get set }
    var backgroundColor: UIColor? { get set }
}

extension InnerTextField: InputField {
    public var inputText: String? {
        return text
    }
}

extension UITextView: InputField {
    public var inputText: String? {
        return text
    }
}
