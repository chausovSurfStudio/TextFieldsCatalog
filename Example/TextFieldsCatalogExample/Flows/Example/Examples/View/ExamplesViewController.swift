//
//  ExamplesViewController.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import UIKit

final class ExamplesViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var emailField: BoxTextField!
    @IBOutlet private weak var passwordField: BoxTextField!

    // MARK: - NSLayoutConstraints

    @IBOutlet private weak var emailHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var passwordHeightConstraint: NSLayoutConstraint!

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

    func setupInitialState(with title: String) {
        configureAppearance(with: title)
    }

}

// MARK: - Appearance

private extension ExamplesViewController {

    func configureAppearance(with title: String) {
        configureNavigationBar(with: title)
        configureBackground()
        configureGestures()
        configureFields()
    }

    func configureNavigationBar(with title: String) {
        navigationItem.title = title
    }

    func configureBackground() {
        view.backgroundColor = Color.Main.background
    }

    func configureGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
    }

    func configureFields() {
        UnderlinedFieldPreset.email.apply(for: emailField as Any)
        UnderlinedFieldPreset.password.apply(for: passwordField as Any)
        emailField.nextInput = passwordField
        passwordField.field.returnKeyType = .done
    }

}

// MARK: - Actions

private extension ExamplesViewController {

    @objc
    func closeKeyboard() {
        view.endEditing(true)
    }

}
