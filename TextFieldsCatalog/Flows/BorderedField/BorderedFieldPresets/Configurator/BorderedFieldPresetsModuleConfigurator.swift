//
//  BorderedFieldPresetsModuleConfigurator.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import UIKit

final class BorderedFieldPresetsModuleConfigurator {

    func configure() -> (UIViewController, BorderedFieldPresetsModuleOutput) {
        let view = BorderedFieldPresetsViewController()
        let presenter = BorderedFieldPresetsPresenter()

        presenter.view = view
        view.output = presenter

        view.modalPresentationStyle = .overFullScreen
        view.modalTransitionStyle = .crossDissolve

        return (view, presenter)
    }

}
