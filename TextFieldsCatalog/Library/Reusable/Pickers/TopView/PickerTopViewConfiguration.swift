//
//  PickerTopViewConfiguration.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 13/05/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

/// Configuration class with parameters for topView into the custom input views with pickers
public final class PickerTopViewConfiguration {
    /// Background color for topView
    let backgroundColor: UIColor
    /// Separators color into the topView. You can setup .clear color for hiding it
    let separatorsColor: UIColor
    /// Configuration for return button
    let button: PickerTopViewButtonConfiguration

    public init(backgroundColor: UIColor,
                separatorsColor: UIColor,
                button: PickerTopViewButtonConfiguration) {
        self.backgroundColor = backgroundColor
        self.separatorsColor = separatorsColor
        self.button = button
    }

    public init() {
        self.backgroundColor = UIColor.white
        self.separatorsColor = UIColor.clear
        self.button = PickerTopViewButtonConfiguration(text: L10n.Button.done,
                                                       activeColor: Color.Button.active,
                                                       highlightedColor: Color.Button.pressed)
    }
}

/// Configuration class with parameters for topView return button
public final class PickerTopViewButtonConfiguration {
    /// Text into the button
    let text: String
    /// Color for button text in normal state
    let activeColor: UIColor
    /// Color for button text in highlighted state
    let highlightedColor: UIColor

    public init(text: String,
                activeColor: UIColor,
                highlightedColor: UIColor) {
        self.text = text
        self.activeColor = activeColor
        self.highlightedColor = highlightedColor
    }
}
