//
//  BorderedFieldPresetsPresenter.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

final class BorderedFieldPresetsPresenter: BorderedFieldPresetsModuleOutput {

    // MARK: - BorderedFieldPresetsModuleOutput

    var onClose: EmptyClosure?
    var onSelectPreset: BorderedFieldPresetClosure?

    // MARK: - Properties

    weak var view: BorderedFieldPresetsViewInput?

}

// MARK: - BorderedFieldPresetsModuleInput

extension BorderedFieldPresetsPresenter: BorderedFieldPresetsModuleInput {
}

// MARK: - BorderedFieldPresetsViewOutput

extension BorderedFieldPresetsPresenter: BorderedFieldPresetsViewOutput {

    func viewLoaded() {
        view?.setupInitialState(with: BorderedFieldPreset.allCases)
    }

    func close() {
        onClose?()
    }

    func selectPreset(_ preset: BorderedFieldPreset) {
        onSelectPreset?(preset)
    }

}
