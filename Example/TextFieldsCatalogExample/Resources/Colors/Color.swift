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
        static let bold = Asset.background.color
        static let regular = Asset.regular.color
        static let active = Asset.active.color
        static let activePress = Asset.activePress.color
        static let text = Asset.text.color
        static let highlighted = Asset.highlighted.color
        static let error = Asset.error.color
        static let placeholderGray = Asset.placeholderGray.color
        static let fieldNormal = Asset.fieldNormal.color
        static let mainButtonText = Asset.mainButtonText.color
    }
    /// Main colors of application
    enum Main {
        static let background = Figma.bold
        static let container = Figma.regular
    }
    /// Colors for labels and button text
    enum Text {
        static let white = Figma.text
    }
    /// Colors for buttons
    enum Button {
        static let active = Figma.active
        static let pressed = Figma.activePress
        static let text = Figma.mainButtonText
    }
    /// Colors for navigation bar
    enum NavBar {
        static let background = Figma.bold
        static let tint = Figma.active
        static let text = Figma.text
    }
    /// Colors for tab bar
    enum TabBar {
        static let itemTint = Figma.text
        static let selectedItemTint = Figma.active
        static let background = Figma.bold
        static let separator = Figma.bold
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
