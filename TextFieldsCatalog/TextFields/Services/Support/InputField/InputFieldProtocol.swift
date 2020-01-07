//
//  InputFieldProtocol.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 07/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit

protocol InputField {
    var inputText: String? { get }
}

extension InnerTextField: InputField {
    var inputText: String? {
        return text
    }
}

extension UITextView: InputField {
    var inputText: String? {
        return text
    }
}
