//
//  InfoPresenter.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 25/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

final class InfoPresenter: InfoModuleOutput {

    // MARK: - InfoModuleOutput

    // MARK: - Properties

    weak var view: InfoViewInput?

}

// MARK: - InfoModuleInput

extension InfoPresenter: InfoModuleInput {
}

// MARK: - InfoViewOutput

extension InfoPresenter: InfoViewOutput {

    func viewLoaded() {
        view?.setupInitialState(with: L10n.Main.Info.description)
    }

}
