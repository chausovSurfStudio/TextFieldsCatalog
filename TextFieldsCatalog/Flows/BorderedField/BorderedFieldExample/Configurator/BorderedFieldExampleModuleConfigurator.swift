//
//  BorderedFieldExampleModuleConfigurator.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import UIKit

final class BorderedFieldExampleModuleConfigurator {

    func configure() -> (UIViewController, BorderedFieldExampleModuleOutput, BorderedFieldExampleModuleInput) {
        let view = BorderedFieldExampleViewController()
        let presenter = BorderedFieldExamplePresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter, presenter)
    }

}
