//
//  ExamplesPresenter.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

final class ExamplesPresenter: ExamplesModuleOutput {

    // MARK: - ExamplesModuleOutput

    // MARK: - Properties

    weak var view: ExamplesViewInput?

}

// MARK: - ExamplesModuleInput

extension ExamplesPresenter: ExamplesModuleInput {
}

// MARK: - ExamplesViewOutput

extension ExamplesPresenter: ExamplesViewOutput {

    func viewLoaded() {
        view?.setupInitialState()
    }

}
