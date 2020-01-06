//
//  FieldExampleModuleOutput.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 24/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

protocol FieldExampleModuleOutput: class {
    var onChangePreset: ((TextFieldType) -> Void)? { get set }
}
