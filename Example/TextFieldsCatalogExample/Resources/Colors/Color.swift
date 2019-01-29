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
        static let bold = UIColor(hexString: "1F2032")
        static let regular = UIColor(hexString: "34364E")
        static let active = UIColor(hexString: "FF9D2B")
        static let activePress = UIColor(hexString: "D47506")
        static let white = UIColor(hexString: "FEFEFE")
        static let buttonPressed = UIColor(hexString: "2B2D43")
    }
    /// Main colors of application
    enum Main {
        static let background = Color.Figma.bold
        static let container = Color.Figma.regular
    }
    /// Colors for labels and button text
    enum Text {
        static let white = Color.Figma.white
    }
    /// Colors for buttons
    enum Button {
        static let active = Color.Figma.active
        static let pressed = Color.Figma.activePress
    }
    /// Colors for navigation bar
    enum NavBar {
        static let background = Color.Figma.bold
        static let tint = Color.Figma.active
        static let text = Color.Figma.white
    }
    /// Colors for cells(buttons)
    enum Cell {
        static let container = Color.Figma.regular
        static let pressed = Color.Figma.buttonPressed
        static let background = Color.Figma.bold
    }
}
