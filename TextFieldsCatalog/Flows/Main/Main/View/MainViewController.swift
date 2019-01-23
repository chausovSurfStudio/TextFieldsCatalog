//
//  MainViewController.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - Properties

    var output: MainViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK: - MainViewInput

extension MainViewController: MainViewInput {

    func setupInitialState() {
        view.backgroundColor = Color.Main.background
    }

}

// MARK: - Actions

private extension MainViewController {

    @IBAction func openBorderedFieldExample(_ sender: Any) {
        output?.openBorderedFieldExample()
    }

}
