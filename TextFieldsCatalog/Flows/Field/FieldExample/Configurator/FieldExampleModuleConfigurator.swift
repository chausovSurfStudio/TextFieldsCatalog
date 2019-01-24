//
//  FieldExampleModuleConfigurator.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 24/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import UIKit

final class FieldExampleModuleConfigurator {

    func configure(with fieldType: TextFieldType) -> (UIViewController, FieldExampleModuleOutput, FieldExampleModuleInput) {
        let view = FieldExampleViewController()
        let presenter = FieldExamplePresenter(with: fieldType)

        presenter.view = view
        view.output = presenter

        return (view, presenter, presenter)
    }

}
