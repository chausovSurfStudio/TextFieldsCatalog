//
//  BorderedFieldExamplePresenter.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

final class BorderedFieldExamplePresenter: BorderedFieldExampleModuleOutput {

    // MARK: - BorderedFieldExampleModuleOutput

    var onClose: EmptyClosure?
    var onChangePreset: EmptyClosure?

    // MARK: - Properties

    weak var view: BorderedFieldExampleViewInput?

}

// MARK: - BorderedFieldExampleModuleInput

extension BorderedFieldExamplePresenter: BorderedFieldExampleModuleInput {

    func applyPreset(_ preset: BorderedFieldPreset) {
        view?.applyPreset(preset)
    }

}

// MARK: - BorderedFieldExampleViewOutput

extension BorderedFieldExamplePresenter: BorderedFieldExampleViewOutput {

    func viewLoaded() {
        view?.setupInitialState(with: .password)
    }

    func close() {
        onClose?()
    }

    func changePreset() {
        onChangePreset?()
    }

}
