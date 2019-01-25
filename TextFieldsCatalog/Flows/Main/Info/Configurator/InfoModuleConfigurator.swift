//
//  InfoModuleConfigurator.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 25/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import UIKit

final class InfoModuleConfigurator {

    func configure() -> (UIViewController, InfoModuleOutput) {
        let view = InfoViewController()
        let presenter = InfoPresenter()

        presenter.view = view
        view.output = presenter

        return (view, presenter)
    }

}
