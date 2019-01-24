//
//  FieldPresetsPresenter.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 24/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

final class FieldPresetsPresenter: FieldPresetsModuleOutput {

    // MARK: - FieldPresetsModuleOutput

    var onClose: EmptyClosure?
    var onSelectPreset: FieldPresetClosure?

    // MARK: - Properties

    weak var view: FieldPresetsViewInput?

    // MARK: - Private Properties

    private let presets: [AppliedPreset]

    // MARK: - Initialization

    init(with presets: [AppliedPreset]) {
        self.presets = presets
    }

}

// MARK: - FieldPresetsModuleInput

extension FieldPresetsPresenter: FieldPresetsModuleInput {
}

// MARK: - FieldPresetsViewOutput

extension FieldPresetsPresenter: FieldPresetsViewOutput {

    func viewLoaded() {
        view?.setupInitialState(with: presets)
    }

    func close() {
        onClose?()
    }

    func selectPreset(_ preset: AppliedPreset) {
        onSelectPreset?(preset)
    }

}
