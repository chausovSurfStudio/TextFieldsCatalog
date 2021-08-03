//
//  StandardEditActions.swift
//  TextFieldsCatalog
//
//  Created by Никита Гагаринов on 03.08.2021.
//  Copyright © 2021 Александр Чаусов. All rights reserved.
//

import UIKit

/// Contains all standard edit actions for disabling it in fields
public enum StandardEditActions {

    case cut
    case copy
    case paste
    case select
    case selectAll
    case delete

    var selector: Selector {
        switch self {
            case .cut:
                return #selector(UIResponderStandardEditActions.cut)
            case .copy:
                return #selector(UIResponderStandardEditActions.copy)
            case .paste:
                return #selector(UIResponderStandardEditActions.paste)
            case .select:
                return #selector(UIResponderStandardEditActions.select)
            case .selectAll:
                return #selector(UIResponderStandardEditActions.selectAll)
            case .delete:
                return #selector(UIResponderStandardEditActions.delete)
        }
    }

}

public extension Array where Element == StandardEditActions {

    static var all: [StandardEditActions] {
        return [.cut, .copy, .paste, .selectAll, .delete]
    }

}
