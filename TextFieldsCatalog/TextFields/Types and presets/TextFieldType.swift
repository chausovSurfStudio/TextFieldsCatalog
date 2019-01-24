//
//  TextFieldType.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

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
}
