//
//  BorderedFieldExampleViewController.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import UIKit
import SurfUtils

final class BorderedFieldExampleViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var changePresetButton: UIButton!
    @IBOutlet private weak var textFieldContainer: UIView!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - Properties

    var output: BorderedFieldExampleViewOutput?

    // MARK: - Private Properties

    private var textField: BorderedTextField?

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

    func setupInitialState(with preset: BorderedFieldPreset) {
        configureAppearance()
        applyPreset(preset)
    }

    func applyPreset(_ preset: BorderedFieldPreset) {
        descriptionLabel.attributedText = preset.description.with(attributes: [.lineHeight(18, font: UIFont.systemFont(ofSize: 14, weight: .regular)),
                                                                               .foregroundColor(Color.Text.white)])
        if let textField = textField {
            textField.removeFromSuperview()
        }
        let newField = BorderedTextField(frame: textFieldContainer.bounds)
        newField.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textFieldContainer.addSubview(newField)
        textField = newField
        preset.apply(for: newField)
    }

}

// MARK: - Actions

private extension BorderedFieldExampleViewController {

    @IBAction func tapOnCloseButton(_ sender: Any) {
        output?.close()
    }

    @IBAction func tapOnResetButton(_ sender: Any) {
        textField?.reset()
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

private extension BorderedFieldExampleViewController {

    func configureAppearance() {
        view.backgroundColor = Color.Main.background
        descriptionLabel.numberOfLines = 0
        configureButtons()
        configureTextField()
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

    func configureTextField() {
        textField?.onShouldReturn = { [weak self] _ in
            self?.textField?.resignFirstResponder()
        }
    }

    func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        view.addGestureRecognizer(tapGesture)
    }

}
