//
//  FieldExampleViewInput.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 24/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

protocol FieldExampleViewInput: class {
    /// Method for setup initial state of view
    func setupInitialState(with fieldType: TextFieldType, preset: AppliedPreset?)

    /// Method for apply some preset
    func applyPreset(_ preset: AppliedPreset)
}
