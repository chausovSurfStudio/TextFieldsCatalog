//
//  TextFieldType.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import TextFieldsCatalog

enum TextFieldType: CaseIterable {
    case underlined
    case box
    case customUnderlined
    case underlinedTextView
    case sumTextField

    var title: String {
        switch self {
        case .underlined:
            return L10n.TextFieldType.Underlined.title
        case .box:
            return L10n.TextFieldType.Box.title
        case .customUnderlined:
            return L10n.TextFieldType.CustomUnderlined.title
        case .underlinedTextView:
            return L10n.TextFieldType.UnderlinedTextView.title
        case .sumTextField:
            return L10n.TextFieldType.SumTextField.title
        }
    }

    var description: String {
        switch self {
        case .underlined:
            return L10n.TextFieldType.Underlined.description
        case .box:
            return L10n.TextFieldType.Box.description
        case .customUnderlined:
            return L10n.TextFieldType.CustomUnderlined.description
        case .underlinedTextView:
            return L10n.TextFieldType.UnderlinedTextView.description
        case .sumTextField:
            return L10n.TextFieldType.SumTextField.description
        }
    }

    var presets: [AppliedPreset] {
        switch self {
        case .underlined, .box, .customUnderlined:
            return UnderlinedFieldPreset.allCases
        case .underlinedTextView:
            return UnderlinedTextViewPreset.allCases
        case .sumTextField:
            return SumFieldPreset.allCases
        }
    }

    /// Returns new instance of needed text field and its default height
    func createField(for frame: CGRect) -> (UIView, CGFloat) {
        switch self {
        case .underlined:
            return (UnderlinedTextField(frame: frame), 77)
        case .box:
            return (BoxTextField(frame: frame), 130)
        case .customUnderlined:
            return (CustomUnderlinedTextField(frame: frame), 64)
        case .underlinedTextView:
            return (UnderlinedTextView(frame: frame), 77)
        case .sumTextField:
            return (SumTextField(frame: frame), 102)
        }
    }

}
