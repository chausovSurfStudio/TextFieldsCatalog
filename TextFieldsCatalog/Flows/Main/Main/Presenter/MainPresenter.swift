//
//  MainPresenter.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

final class MainPresenter: MainModuleOutput {

    // MARK: - MainModuleOutput

    var onFieldOpen: TextFieldTypeClosure?

    // MARK: - Properties

    weak var view: MainViewInput?

}

// MARK: - MainModuleInput

extension MainPresenter: MainModuleInput {
}

// MARK: - MainViewOutput

extension MainPresenter: MainViewOutput {

    func viewLoaded() {
        view?.setupInitialState(with: [.message("Какое-то сообщение о том, зачем вообще все это сделано"),
                                       .field(.bordered)],
                                title: "Каталог")
    }

    func openField(with type: TextFieldType) {
        onFieldOpen?(type)
    }

}
