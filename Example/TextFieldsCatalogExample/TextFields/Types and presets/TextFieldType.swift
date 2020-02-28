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

    var title: String {
        switch self {
        case .underlined:
            return L10n.Textfieldtype.Underlined.title
        case .box:
            return L10n.Textfieldtype.Box.title
        case .customUnderlined:
            return L10n.Textfieldtype.Customunderlined.title
        case .underlinedTextView:
            return L10n.Textfieldtype.Underlinedtextview.title
        }
    }

    var description: String {
        switch self {
        case .underlined:
            return L10n.Textfieldtype.Underlined.description
        case .box:
            return L10n.Textfieldtype.Box.description
        case .customUnderlined:
            return L10n.Textfieldtype.Customunderlined.description
        case .underlinedTextView:
            return L10n.Textfieldtype.Underlinedtextview.description
        }
    }

    var presets: [AppliedPreset] {
        switch self {
        case .underlined, .box, .customUnderlined:
            return UnderlinedFieldPreset.allCases
        case .underlinedTextView:
            return UnderlinedTextViewPreset.allCases
        }
    }

    /// Returns new instance of needed text field and its default height
    func createField(for frame: CGRect) -> (UIView, CGFloat) {
        switch self {
        case .underlined:
            let height: CGFloat = 77
            let field = UnderlinedTextField(frame: frame)
            field.heightLayoutPolicy = .flexible(height, 5)
            return (field, height)
        case .box:
            return (BoxTextField(frame: frame), 130)
        case .customUnderlined:
            return (CustomUnderlinedTextField(frame: frame), 64)
        case .underlinedTextView:
            return (UnderlinedTextView(frame: frame), 77)
        }
    }

}
