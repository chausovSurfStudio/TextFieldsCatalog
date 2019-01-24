//
//  FieldPresetsViewController.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 24/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import UIKit

final class FieldPresetsViewController: UIViewController {

    // MARK: - Properties

    var output: FieldPresetsViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

}

// MARK: - FieldPresetsViewInput

extension FieldPresetsViewController: FieldPresetsViewInput {

    func setupInitialState() {
    }

}
