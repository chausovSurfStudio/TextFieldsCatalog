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
        static let separator = UIColor(hexString: "4A4D70")
        static let light = UIColor(hexString: "9FACC7")
        static let active = UIColor(hexString: "FF9D2B")
        static let activePress = UIColor(hexString: "D47506")
        static let red = UIColor(hexString: "FF4747")
        static let green = UIColor(hexString: "4FCB82")
        static let black = UIColor(hexString: "000000")
        static let white = UIColor(hexString: "FEFEFE")
        static let gold = UIColor(hexString: "FFD8A3")
        static let gradientBallance = UIColor(hexString: "373951")
        static let buttonPressed = UIColor(hexString: "2B2D43")
    }
    /// Main colors of application
    enum Main {
        static let background = Color.Figma.bold
        static let container = Color.Figma.regular
        static let light = Color.Figma.separator
        static let active = Color.Figma.active
        static let red = Color.Figma.red
        static let green = Color.Figma.green
    }
    /// Colors for labels and button text
    enum Text {
        static let white = Color.Figma.white
        static let black = Color.Figma.black
        static let gray = Color.Figma.light
        static let red = Color.Figma.red
        static let green = Color.Figma.green
        static let active = Color.Figma.active
        static let pressed = Color.Figma.activePress
        static let disabled = Color.Figma.bold
        static let gold = Color.Figma.gold
    }
    /// Colors for buttons
    enum Button {
        static let active = Color.Figma.active
        static let pressed = Color.Figma.activePress
        static let disabled = Color.Figma.regular
        /// Action button in header of account screen
        enum AccountAction {
            static let active = Color.Figma.regular
            static let pressed = Color.Figma.buttonPressed
        }
        /// Colors for number button on a custom keyboard view
        enum Keyboard {
            static let active = Color.Figma.regular
            static let pressed = Color.Figma.active
        }
        enum PlainLabel {
            static let active = Color.Figma.light
            static let pressed = Color.Figma.buttonPressed
        }
    }
    /// Colors for navigation bar
    enum NavBar {
        static let background = Color.Figma.bold
        static let tint = Color.Figma.active
        static let text = Color.Figma.white
    }
    /// Colors for snack bar
    enum SnackBar {
        static let error = Color.Figma.red
        static let success = Color.Figma.green
    }
    /// Colors for Tab Bar
    enum TabBar {
        static let background = UIColor(hexString: "181926")
        static let itemTint = Color.Figma.light
        static let selectedItemTint = Color.Figma.active
    }
    /// Colors for custom action sheet
    enum ActionSheet {
        /// Colors for custom action sheet cell
        enum Cell {
            static let active = Color.Figma.regular
            static let pressed = Color.Figma.buttonPressed
            static let separator = UIColor(hexString: "0F0F19")
        }
    }
    /// Colors for cells(buttons)
    enum Cell {
        static let container = Color.Figma.regular
        static let pressed = Color.Figma.buttonPressed
        static let background = Color.Figma.bold
    }
}
