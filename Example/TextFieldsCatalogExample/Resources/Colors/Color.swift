//
//  Color.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

/// Contains all projects color constants
enum Color {
    /// Main color with its names from Figma
    private enum Figma {
        static let bold = Asset.Colors.background.color
        static let regular = Asset.Colors.regular.color
        static let active = Asset.Colors.active.color
        static let activePress = Asset.Colors.activePress.color
        static let text = Asset.Colors.text.color
        static let highlighted = Asset.Colors.highlighted.color
        static let error = Asset.Colors.error.color
        static let placeholderGray = Asset.Colors.placeholderGray.color
        static let fieldNormal = Asset.Colors.fieldNormal.color
        static let mainButtonText = Asset.Colors.mainButtonText.color
    }
    /// Main colors of application
    enum Main {
        static let background = Color.Figma.bold
        static let container = Color.Figma.regular
    }
    /// Colors for labels and button text
    enum Text {
        static let white = Color.Figma.text
    }
    /// Colors for buttons
    enum Button {
        static let active = Color.Figma.active
        static let pressed = Color.Figma.activePress
        static let text = Color.Figma.mainButtonText
    }
    /// Colors for navigation bar
    enum NavBar {
        static let background = Color.Figma.bold
        static let tint = Color.Figma.active
        static let text = Color.Figma.text
    }
    /// Colors for cells(buttons)
    enum Cell {
        static let container = Color.Figma.regular
        static let pressed = Color.Figma.highlighted
        static let background = Color.Figma.bold
    }
    /// Custom Underline TextField
    enum UnderlineTextField {
        static let error = Color.Figma.error
        static let tint = Color.Figma.active
        static let placeholder = Color.Figma.placeholderGray
        static let normal = Color.Figma.fieldNormal
        static let text = Color.Figma.text

        enum ActionButton {
            static let normal = Color.Figma.placeholderGray
            static let pressed = Color.Figma.placeholderGray.withAlphaComponent(0.5)
        }
    }
}
