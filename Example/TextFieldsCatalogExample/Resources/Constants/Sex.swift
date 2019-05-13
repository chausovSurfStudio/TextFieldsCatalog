//
//  Sex.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 13/05/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

enum Sex: CaseIterable {
    case male
    case female

    var value: String {
        switch self {
        case .male:
            return L10n.Constants.Sex.male
        case .female:
            return L10n.Constants.Sex.female
        }
    }

    static func sex(by value: String?) -> Sex? {
        guard let value = value else {
            return nil
        }
        for item in Sex.allCases.map({ ($0, $0.value) }) {
            if item.1 == value {
                return item.0
            }
        }
        return nil
    }

}
