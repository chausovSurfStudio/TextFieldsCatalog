//
//  MainButton.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 25/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

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

}

private extension MainButton {

    func setupInitialState() {
        activeBackgroundColor = Color.Button.active
        highlightedBackgroundColor = Color.Button.pressed
        activeTitleColor = Color.Text.white
        highlightedTitleColor = Color.Text.white
        layer.cornerRadius = 12
        titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        layer.masksToBounds = true
    }

}
