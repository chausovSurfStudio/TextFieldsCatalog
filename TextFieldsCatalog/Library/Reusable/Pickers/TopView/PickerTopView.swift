//
//  PickerTopView.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 12/05/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

public final class PickerTopView: UIView, ToolBarInterface {

    // MARK: - Constants

    private enum Constants {
        static let navigationButtonWidth: CGFloat = 35
        static let defaultMargin: CGFloat = 10
    }

    // MARK: - Subviews

    private let topSeparator = UIView()
    private let bottomSeparator = UIView()
    private let returnButton = CommonButton()
    private let leftNavigationButton = IconButton()
    private let rightNavigationButton = IconButton()

    // MARK: - NSLayoutConstraints

    @IBOutlet private weak var leftNavigationButtonWidth: NSLayoutConstraint!

    // MARK: - Public Properties

    public weak var guidedField: GuidedTextField?
    public var configuration = PickerTopViewConfiguration() {
        didSet {
            configureAppearance()
        }
    }

    // MARK: - Initialization

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UIView

    override public func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

    // MARK: - Public Methods

    public func updateNavigationButtons() {
        leftNavigationButton.isHidden = !(guidedField?.havePreviousInput ?? false)
        rightNavigationButton.isHidden = !(guidedField?.haveNextInput ?? false)

        let leftButtonWidth: CGFloat = leftNavigationButton.isHidden ? 0 : 35
        leftNavigationButtonWidth.constant = leftButtonWidth
        layoutIfNeeded()
    }

}

// MARK: - Configure

private extension PickerTopView {

    func configureAppearance() {
        backgroundColor = configuration.backgroundColor
        configureSeparators()
        configureNavigationButtons()
        configureReturnButton()
    }

    func configureSeparators() {
        topSeparator.apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)

            $0.backgroundColor = configuration.separatorsColor

            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: leadingAnchor),
                $0.topAnchor.constraint(equalTo: topAnchor),
                $0.trailingAnchor.constraint(equalTo: trailingAnchor),
                $0.heightAnchor.constraint(equalToConstant: 1)
            ])
        }

        bottomSeparator.apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)

            $0.backgroundColor = configuration.separatorsColor

            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: leadingAnchor),
                $0.bottomAnchor.constraint(equalTo: bottomAnchor),
                $0.trailingAnchor.constraint(equalTo: trailingAnchor),
                $0.heightAnchor.constraint(equalToConstant: 1)
            ])
        }

        
    }

    func configureNavigationButtons() {
        leftNavigationButton.apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)

            $0.setImageForAllState(AssetManager().getImage("leftArrow"),
                                   normalColor: configuration.button.activeColor,
                                   pressedColor: configuration.button.highlightedColor)

            leftNavigationButtonWidth = $0.widthAnchor.constraint(equalToConstant: Constants.navigationButtonWidth)
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: leadingAnchor,
                                            constant: Constants.defaultMargin),
                $0.bottomAnchor.constraint(equalTo: bottomAnchor),
                $0.topAnchor.constraint(equalTo: topAnchor),
                leftNavigationButtonWidth
            ])

            $0.addTarget(self, action: #selector(switchToPreviousInput(_:)), for: .touchUpInside)
        }

        rightNavigationButton.apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)

            $0.setImageForAllState(AssetManager().getImage("rightArrow"),
                                   normalColor: configuration.button.activeColor,
                                   pressedColor: configuration.button.highlightedColor)

            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: leftNavigationButton.trailingAnchor),
                $0.bottomAnchor.constraint(equalTo: bottomAnchor),
                $0.topAnchor.constraint(equalTo: topAnchor),
                $0.widthAnchor.constraint(equalToConstant: Constants.navigationButtonWidth)
            ])

            $0.addTarget(self, action: #selector(switchToNextInput(_:)), for: .touchUpInside)
        }


    }

    func configureReturnButton() {
        returnButton.apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)

            $0.setTitleForAllState(configuration.button.text)
            $0.activeTitleColor = configuration.button.activeColor
            $0.highlightedTitleColor = configuration.button.highlightedColor

            NSLayoutConstraint.activate([
                $0.bottomAnchor.constraint(equalTo: bottomAnchor),
                $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultMargin),
                $0.topAnchor.constraint(equalTo: topAnchor),
                $0.leadingAnchor.constraint(greaterThanOrEqualTo: rightNavigationButton.trailingAnchor,
                                            constant: Constants.defaultMargin)
            ])

            $0.addTarget(self, action: #selector(performAction(_:)), for: .touchUpInside)
        }
    }

}

// MARK: - Actions

private extension PickerTopView {

    @objc
    func performAction(_ sender: CommonButton) {
        guidedField?.processReturnAction()
    }

    @objc
    func switchToPreviousInput(_ sender: IconButton) {
        guidedField?.switchToPreviousInput()
    }

    @objc
    func switchToNextInput(_ sender: IconButton) {
        guidedField?.switchToNextInput()
    }

}
