//
//  BorderedFieldExampleViewOutput.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

protocol BorderedFieldExampleViewOutput {
    /// Notify presenter that view is ready
    func viewLoaded()

    /// Notify presenter that user wants to close current module
    func close()
}
