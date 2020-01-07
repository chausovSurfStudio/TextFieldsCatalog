//
//  ExamplesModuleConfigurator.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import UIKit

final class ExamplesModuleConfigurator {

    func configure() -> (UIViewController, ExamplesModuleOutput) {
        let view = ExamplesViewController()
        let presenter = ExamplesPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }

}
