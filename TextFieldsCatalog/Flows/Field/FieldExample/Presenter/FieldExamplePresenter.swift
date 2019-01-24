//
//  FieldExamplePresenter.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 24/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

final class FieldExamplePresenter: FieldExampleModuleOutput {

    // MARK: - FieldExampleModuleOutput

    var onClose: EmptyClosure?
    var onChangePreset: EmptyClosure?

    // MARK: - Properties

    weak var view: FieldExampleViewInput?

    // MARK: - Private Properties

    private let fieldType: TextFieldType

    // MARK: - Initialization

    init(with fieldType: TextFieldType) {
        self.fieldType = fieldType
    }

}

// MARK: - FieldExampleModuleInput

extension FieldExamplePresenter: FieldExampleModuleInput {

    func applyPreset(_ preset: AppliedPreset) {
        view?.applyPreset(preset)
    }

}

// MARK: - FieldExampleViewOutput

extension FieldExamplePresenter: FieldExampleViewOutput {

    func viewLoaded() {
        view?.setupInitialState(with: fieldType, preset: BorderedFieldPreset.password)
    }

    func close() {
        onClose?()
    }

    func changePreset() {
        onChangePreset?()
    }

}
