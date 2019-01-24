//
//  FieldPresetsViewInput.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 24/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

protocol FieldPresetsViewInput: class {
    /// Method for setup initial state of view
    func setupInitialState(with presets: [AppliedPreset])
}
