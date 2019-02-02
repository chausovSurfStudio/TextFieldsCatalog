//
//  HeightLayoutPolicy.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 02/02/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

public enum HeightLayoutPolicy {
    /// Fixed height of text field
    case fixed
    /// Flexible height of text field.
    /// Also allows you to configure minimal height for text field and bottom space value under hint label
    case flexible(CGFloat, CGFloat)
}
