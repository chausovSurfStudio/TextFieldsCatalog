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
    /// Also allows you to configure minimal height for text field and bottom space value under hint label.
    /// The resulting height is obtained as sum of y-coordinate of the hint label, it's height and bottomSpace value.
    @available(*, deprecated, message: "Use `elastic(_,_,_)` instead with ignoreEmptyHint == false for backward capability. It's case will be removed later")
    case flexible(CGFloat, CGFloat)
    /**
     Flexible height of text field.
     Also allows you to configure minimal height for text field and bottom space value under hint label.

     Final height depends on `ignoreEmptyHint` value:
     - if `ignoreEmptyHint` == true, then if you hint is empty - then algoritm will use `minHeight` as view height
     - if `ignoreEmptyHint` == false, then resulting height is obtained always as sum of y-coordinate of the hint label, it's height and bottomSpace value
     */
    case elastic(minHeight: CGFloat, bottomSpace: CGFloat, ignoreEmptyHint: Bool)
}
