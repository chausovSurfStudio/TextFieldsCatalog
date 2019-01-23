//
//  BorderedFieldPresetsModuleOutput.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

protocol BorderedFieldPresetsModuleOutput: class {
    var onClose: EmptyClosure? { get set }
    var onSelectPreset: BorderedFieldPresetClosure? { get set }
}
