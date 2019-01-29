//
//  Color.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 28/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

/// Contains all projects color constants
enum Color {
    /// Main color with its names from Figma
    private enum Figma {
        static let bold = UIColor(hexString: "1F2032")
        static let regular = UIColor(hexString: "34364E")
        static let light = UIColor(hexString: "9FACC7")
        static let active = UIColor(hexString: "FF9D2B")
        static let activePress = UIColor(hexString: "D47506")
        static let red = UIColor(hexString: "FF4747")
        static let black = UIColor(hexString: "000000")
        static let white = UIColor(hexString: "FEFEFE")
    }
    /// Main colors of application
    enum Main {
        static let background = Color.Figma.bold
        static let container = Color.Figma.regular
        static let active = Color.Figma.active
        static let red = Color.Figma.red
    }
    /// Colors for labels and button text
    enum Text {
        static let white = Color.Figma.white
        static let black = Color.Figma.black
        static let gray = Color.Figma.light
        static let red = Color.Figma.red
        static let active = Color.Figma.active
    }
    /// Colors for buttons
    enum Button {
        static let active = Color.Figma.active
        static let pressed = Color.Figma.activePress
        static let disabled = Color.Figma.regular
    }
}
