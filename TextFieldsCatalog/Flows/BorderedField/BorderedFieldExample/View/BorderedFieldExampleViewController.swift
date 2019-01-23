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
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var textField: BorderedTextField!

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
        configureAppearance()

        textField.configure(placeholder: "Пароль", maxLength: nil)
        textField.configure(correction: .no, keyboardType: .asciiCapable)
        textField.disablePasteAction()
        textField.setHint("Текст подсказки")
        textField.setReturnKeyType(.next)
        textField.setTextFieldMode(.password)

        let validator = TextFieldValidator(minLength: 8, maxLength: 20, regex: Regex.password)
        validator.shortErrorText = "Пароль слишком короткий"
        textField.validator = validator

        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.password)

        textField.onShouldReturn = { [weak self] _ in
            self?.textField.resignFirstResponder()
        }
    }

}

// MARK: - Actions

private extension BorderedFieldExampleViewController {

    @IBAction func tapOnCloseButton(_ sender: Any) {
        output?.close()
    }

    @IBAction func tapOnResetButton(_ sender: Any) {
        textField.reset()
    }

}

// MARK: - Configure

private extension BorderedFieldExampleViewController {

    func configureAppearance() {
        view.backgroundColor = Color.Main.background
        closeButton.setImage(UIImage(asset: Asset.close), for: .normal)
        closeButton.tintColor = Color.Main.active
        resetButton.setTitle("Сбросить", for: .normal)
        resetButton.tintColor = Color.Main.active
    }

}
