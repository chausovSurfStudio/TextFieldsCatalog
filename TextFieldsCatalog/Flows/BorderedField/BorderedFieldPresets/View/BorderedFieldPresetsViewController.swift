//
//  BorderedFieldPresetsViewController.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import UIKit

final class BorderedFieldPresetsViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var container: UIView!

    // MARK: - Properties

    var output: BorderedFieldPresetsViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

}

// MARK: - BorderedFieldPresetsViewInput

extension BorderedFieldPresetsViewController: BorderedFieldPresetsViewInput {

    func setupInitialState(with presets: [BorderedFieldPreset]) {
        configureAppearance()
    }

}

// MARK: - Configure

private extension BorderedFieldPresetsViewController {

    func configureAppearance() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        configureContainer()
        configureGestures()
    }

    func configureContainer() {
        container.layer.cornerRadius = 12
        container.layer.masksToBounds = true
    }

    func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        view.addGestureRecognizer(tapGesture)
    }

}

// MARK: - Actions

private extension BorderedFieldPresetsViewController {

    @objc
    func handleBackgroundTap() {
        output?.close()
    }

}
