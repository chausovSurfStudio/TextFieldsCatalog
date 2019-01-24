//
//  FieldPresetsPresenter.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 24/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

final class FieldPresetsPresenter: FieldPresetsModuleOutput {

    // MARK: - FieldPresetsModuleOutput

    // MARK: - Properties

    weak var view: FieldPresetsViewInput?

}

// MARK: - FieldPresetsModuleInput

extension FieldPresetsPresenter: FieldPresetsModuleInput {
}

// MARK: - FieldPresetsViewOutput

extension FieldPresetsPresenter: FieldPresetsViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

}
