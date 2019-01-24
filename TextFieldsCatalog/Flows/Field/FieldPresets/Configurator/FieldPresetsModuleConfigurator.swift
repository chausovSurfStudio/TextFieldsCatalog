//
//  FieldPresetsModuleConfigurator.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 24/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import UIKit

final class FieldPresetsModuleConfigurator {

    func configure() -> (UIViewController, FieldPresetsModuleOutput) {
        let view = FieldPresetsViewController()
        let presenter = FieldPresetsPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }

}
