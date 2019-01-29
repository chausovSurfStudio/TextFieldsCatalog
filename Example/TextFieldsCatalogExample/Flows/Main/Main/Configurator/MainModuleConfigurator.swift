//
//  MainModuleConfigurator.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import UIKit

final class MainModuleConfigurator {

    func configure() -> (UIViewController, MainModuleOutput) {
        let view = MainViewController()
        let presenter = MainPresenter()

        presenter.view = view
        view.output = presenter

        let navigationController = CommonNavigationController(rootViewController: view)
        return (navigationController, presenter)
    }

}
