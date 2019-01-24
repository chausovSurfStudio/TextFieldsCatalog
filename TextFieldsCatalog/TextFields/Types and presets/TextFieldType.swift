//
//  TextFieldType.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

enum TextFieldType {
    case bordered

    var title: String {
        switch self {
        case .bordered:
            return L10n.Textfieldtype.Bordered.title
        }
    }

    var description: String {
        switch self {
        case .bordered:
            return L10n.Textfieldtype.Bordered.description
        }
    }

    var presets: [AppliedPreset] {
        switch self {
        case .bordered:
            return BorderedFieldPreset.allCases
        }
    }

    /// Returns new instance of needed text field and its default height
    func createField(for frame: CGRect) -> (UIView, CGFloat) {
        switch self {
        case .bordered:
            return (BorderedTextField(frame: frame), 130)
        }
    }

}
