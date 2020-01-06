//
//  ExamplesViewController.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import UIKit

final class ExamplesViewController: UIViewController {

    // MARK: - Properties

    var output: ExamplesViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

}

// MARK: - ExamplesViewInput

extension ExamplesViewController: ExamplesViewInput {

    func setupInitialState() {
        view.backgroundColor = Color.Main.background
        navigationItem.title = "Примеры"
    }

}
