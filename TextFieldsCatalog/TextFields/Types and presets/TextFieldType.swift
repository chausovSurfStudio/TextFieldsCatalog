//
//  TextFieldType.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

enum TextFieldType: CaseIterable {
    case bordered
    case underlined

    var title: String {
        switch self {
        case .bordered:
            return L10n.Textfieldtype.Bordered.title
        case .underlined:
            return L10n.Textfieldtype.Underlined.title
        }
    }

    var description: String {
        switch self {
        case .bordered:
            return L10n.Textfieldtype.Bordered.description
        case .underlined:
            return L10n.Textfieldtype.Underlined.description
        }
    }

    var presets: [AppliedPreset] {
        switch self {
        case .bordered:
            return BorderedFieldPreset.allCases
        case .underlined:
            return UnderlinedFieldPreset.allCases
        }
    }

    /// Returns new instance of needed text field and its default height
    func createField(for frame: CGRect) -> (UIView, CGFloat) {
        switch self {
        case .bordered:
            return (BorderedTextField(frame: frame), 130)
        case .underlined:
            return (UnderlinedTextField(frame: frame), 77)
        }
    }

}
