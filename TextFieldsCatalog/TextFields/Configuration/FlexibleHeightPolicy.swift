//
//  FlexibleHeightPolicy.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 08/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

public struct FlexibleHeightPolicy {

    // MARK: - Properties

    let minHeight: CGFloat
    /// offset between hint label and view bottom
    let bottomOffset: CGFloat

    // MARK: - Initialization

    public init(minHeight: CGFloat, bottomOffset: CGFloat) {
        self.minHeight = minHeight
        self.bottomOffset = bottomOffset
    }

}
