//
//  BorderedFieldExampleViewController.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import UIKit

final class BorderedFieldExampleViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var closeButton: UIButton!

    // MARK: - Properties

    var output: BorderedFieldExampleViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK: - BorderedFieldExampleViewInput

extension BorderedFieldExampleViewController: BorderedFieldExampleViewInput {

    func setupInitialState() {
        view.backgroundColor = Color.Main.background
        closeButton.setImage(UIImage(asset: Asset.close), for: .normal)
    }

}

// MARK: - Actions

private extension BorderedFieldExampleViewController {

    @IBAction func tapOnCloseButton(_ sender: Any) {
        output?.close()
    }

}
