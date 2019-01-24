//
//  FieldExampleViewController.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 24/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import UIKit
import SurfUtils

final class FieldExampleViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var changePresetButton: UIButton!
    @IBOutlet private weak var textFieldContainer: UIView!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - Properties

    var output: FieldExampleViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK: - FieldExampleViewInput

extension FieldExampleViewController: FieldExampleViewInput {

    func setupInitialState(with fieldType: TextFieldType) {
        configureAppearance()
    }

}

// MARK: - Actions

private extension FieldExampleViewController {

    @IBAction func tapOnCloseButton(_ sender: Any) {
        output?.close()
    }

    @IBAction func tapOnResetButton(_ sender: Any) {
//        textField?.reset()
    }

    @IBAction func tapOnChangePresetButton(_ sender: Any) {
        output?.changePreset()
    }

    @objc
    func handleBackgroundTap() {
        view.endEditing(true)
    }

}

// MARK: - Configure

private extension FieldExampleViewController {

    func configureAppearance() {
        view.backgroundColor = Color.Main.background
        descriptionLabel.numberOfLines = 0
        configureButtons()
        configureGestures()
    }

    func configureButtons() {
        closeButton.setImage(UIImage(asset: Asset.close), for: .normal)
        closeButton.tintColor = Color.Main.active
        resetButton.setTitle(L10n.Button.reset, for: .normal)
        resetButton.tintColor = Color.Main.active
        changePresetButton.setTitle(L10n.Button.changePreset, for: .normal)
        changePresetButton.tintColor = Color.Main.active
    }

    func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        view.addGestureRecognizer(tapGesture)
    }

}
