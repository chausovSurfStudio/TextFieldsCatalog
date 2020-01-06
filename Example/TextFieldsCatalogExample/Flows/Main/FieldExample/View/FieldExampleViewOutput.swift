//
//  FieldExampleViewOutput.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 24/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

protocol FieldExampleViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()

    /// notify presenter that user wants to change preset
    func changePreset()
}
