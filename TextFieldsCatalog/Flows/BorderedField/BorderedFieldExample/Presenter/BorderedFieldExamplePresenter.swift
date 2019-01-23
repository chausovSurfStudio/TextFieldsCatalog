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

    // MARK: - Properties

    weak var view: BorderedFieldExampleViewInput?

}

// MARK: - BorderedFieldExampleModuleInput

extension BorderedFieldExamplePresenter: BorderedFieldExampleModuleInput {
}

// MARK: - BorderedFieldExampleViewOutput

extension BorderedFieldExamplePresenter: BorderedFieldExampleViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

    func close() {
        onClose?()
    }

}
