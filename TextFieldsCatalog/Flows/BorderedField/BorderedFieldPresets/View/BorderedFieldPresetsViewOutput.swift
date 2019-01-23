//
//  BorderedFieldPresetsViewOutput.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

protocol BorderedFieldPresetsViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()

    /// Notify presenter that user wants to close module
    func close()

    /// Notify presenter that user select some preset
    func selectPreset(_ preset: BorderedFieldPreset)
}
