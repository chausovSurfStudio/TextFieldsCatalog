//
//  PickerTopView.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 12/05/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

final class PickerTopView: InnerDesignableView {

    // MARK: - IBOutlets

    @IBOutlet private weak var topSeparator: UIView!
    @IBOutlet private weak var bottomSeparator: UIView!
    @IBOutlet private weak var returnButton: CommonButton!

    // MARK: - Properties

    var onReturn: (() -> Void)?
    var configuration = PickerTopViewConfiguration() {
        didSet {
            configureAppearance()
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UIView

    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

}

// MARK: - Configure

private extension PickerTopView {

    func configureAppearance() {
        view.backgroundColor = configuration.backgroundColor
        topSeparator.backgroundColor = configuration.separatorsColor
        bottomSeparator.backgroundColor = configuration.separatorsColor
        returnButton.setTitleForAllState(configuration.button.text)
        returnButton.activeTitleColor = configuration.button.activeColor
        returnButton.highlightedTitleColor = configuration.button.highlightedColor
    }

}

// MARK: - Actions

private extension PickerTopView {

    @IBAction func performAction(_ sender: CommonButton) {
        onReturn?()
    }

}
