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
    @IBOutlet private weak var leftNavigationButton: IconButton!
    @IBOutlet private weak var rightNavigationButton: IconButton!

    // MARK: - NSLayoutConstraints

    @IBOutlet private weak var leftNavigationButtonWidth: NSLayoutConstraint!

    // MARK: - Properties

    var onReturn: (() -> Void)?
    var onSwitchToPreviousInput: (() -> Void)?
    var onSwitchToNextInput: (() -> Void)?
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

    // MARK: - Internal Methods

    func configureNavigationButtons(showBackButton backButton: Bool, nextButton: Bool) {
        leftNavigationButton.isHidden = !backButton
        rightNavigationButton.isHidden = !nextButton
        if !backButton {
            leftNavigationButtonWidth.constant = 0
        }
    }

}

// MARK: - Configure

private extension PickerTopView {

    func configureAppearance() {
        view.backgroundColor = configuration.backgroundColor
        configureSeparators()
        configureNavigationButtons()
        configureReturnButton()
    }

    func configureSeparators() {
        topSeparator.backgroundColor = configuration.separatorsColor
        bottomSeparator.backgroundColor = configuration.separatorsColor
    }

    func configureNavigationButtons() {
        leftNavigationButton.setImageForAllState(AssetManager().getImage("leftArrow"),
                                                 normalColor: configuration.button.activeColor,
                                                 pressedColor: configuration.button.highlightedColor)
        rightNavigationButton.setImageForAllState(AssetManager().getImage("rightArrow"),
                                                  normalColor: configuration.button.activeColor,
                                                  pressedColor: configuration.button.highlightedColor)
    }

    func configureReturnButton() {
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

    @IBAction func switchToPreviousInput(_ sender: IconButton) {
        onSwitchToPreviousInput?()
    }

    @IBAction func switchToNextInput(_ sender: IconButton) {
        onSwitchToNextInput?()
    }

}
