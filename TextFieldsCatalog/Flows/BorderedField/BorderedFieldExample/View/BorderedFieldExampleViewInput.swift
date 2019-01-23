//
//  BorderedFieldExampleViewInput.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

protocol BorderedFieldExampleViewInput: class {
    /// Method for setup initial state of view
    func setupInitialState(with preset: BorderedFieldPreset)

    /// Method for apply some preset
    func applyPreset(_ preset: BorderedFieldPreset)
}
