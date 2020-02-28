//
//  InfoViewController.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 25/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import UIKit
import SurfUtils

final class InfoViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - Properties

    var output: InfoViewOutput?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

}

// MARK: - InfoViewInput

extension InfoViewController: InfoViewInput {

    func setupInitialState(with description: String, title: String) {
        view.backgroundColor = Color.Main.background
        navigationItem.title = title
        descriptionLabel.numberOfLines = 0
        descriptionLabel.attributedText = description.with(attributes: [.lineHeight(20, font: UIFont.systemFont(ofSize: 14, weight: .regular)),
                                                                        .foregroundColor(Color.Text.white)])
    }

}
