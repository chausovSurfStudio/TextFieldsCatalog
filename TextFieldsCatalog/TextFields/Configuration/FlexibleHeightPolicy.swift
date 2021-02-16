//
//  FlexibleHeightPolicy.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 08/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit

/**
 Flexible height policy for text field/view.
 Also allows you to configure minimal height for input field and bottom space value under hint label.
 */
public struct FlexibleHeightPolicy {

    // MARK: - Properties

    let minHeight: CGFloat
    /// additional offset (usually used for offset between hintLabel and textField/textView)
    let bottomOffset: CGFloat
    /**
    Final height depends on `ignoreEmptyHint` value:
    - if `ignoreEmptyHint` == true, then the algorithm will add bottomOffset to the final height only if the height of the tooltip is not zero
    - if `ignoreEmptyHint` == false, then resulting height is obtained always as sum of all elements heights and offsets between it
    */
    let ignoreEmptyHint: Bool

    // MARK: - Initialization

    public init(minHeight: CGFloat,
                bottomOffset: CGFloat,
                ignoreEmptyHint: Bool) {
        self.minHeight = minHeight
        self.bottomOffset = bottomOffset
        self.ignoreEmptyHint = ignoreEmptyHint
    }

}
