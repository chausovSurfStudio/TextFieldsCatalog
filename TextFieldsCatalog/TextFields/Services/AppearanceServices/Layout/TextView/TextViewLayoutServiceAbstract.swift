//
//  TextViewLayoutServiceAbstract.swift
//  TextFieldsCatalog
//
//  Created by al.filimonov on 10.04.2021.
//

import UIKit

/// Service to layout textView.
/// You can use `TextViewLayoutServiceDefault` or implement your own
public protocol TextViewLayoutServiceAbstract {

    func layout(textView: UITextView,
                hintLabel: UILabel,
                clearButton: UIButton,
                in superview: UIView) -> TextViewLayoutServiceOutput

}
