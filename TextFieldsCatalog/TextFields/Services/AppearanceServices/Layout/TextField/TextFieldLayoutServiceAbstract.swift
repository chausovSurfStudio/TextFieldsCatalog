//
//  TextFieldLayoutService.swift
//  TextFieldsCatalog
//
//  Created by al.filimonov on 10.04.2021.
//

import UIKit

/// Service to layout textField.
/// You can use `TextFieldLayoutServiceDefault` or implement your own
public protocol TextFieldLayoutServiceAbstract {

    func layout(textField: InnerTextField,
                hintLabel: UILabel,
                actionButton: UIButton,
                in superview: UIView)

}
