//
//  MainButton.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 25/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import TextFieldsCatalog

final class MainButton: CommonButton {

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInitialState()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialState()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupInitialState()
    }

}

private extension MainButton {

    func setupInitialState() {
        activeBackgroundColor = Color.Button.active
        highlightedBackgroundColor = Color.Button.pressed
        activeTitleColor = Color.Button.text
        highlightedTitleColor = Color.Button.text
        layer.cornerRadius = 12
        titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        layer.masksToBounds = true
    }

}
