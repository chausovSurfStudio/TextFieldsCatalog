//
//  FieldService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 10/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

final class FieldService {

    // MARK: - Private Properties

    private let field: InputField?
    private var configuration: TextFieldConfiguration
    private var backgroundConfiguration: BackgroundConfiguration

    // MARK: - Initialization

    init(field: InputField,
         configuration: TextFieldConfiguration,
         backgroundConfiguration: BackgroundConfiguration) {
        self.field = field
        self.configuration = configuration
        self.backgroundConfiguration = backgroundConfiguration
    }

    // MARK: - Internal Methods

    func setup(configuration: TextFieldConfiguration,
               backgroundConfiguration: BackgroundConfiguration) {
        self.configuration = configuration
        self.backgroundConfiguration = backgroundConfiguration
    }

    func configureBackground() {
        field?.superview?.backgroundColor = backgroundConfiguration.color
        field?.backgroundColor = UIColor.clear
    }

    func configure(textField: InnerTextField) {
        textField.font = configuration.font
        textField.textColor = configuration.colors.normal
        textField.tintColor = configuration.tintColor
        textField.returnKeyType = .done
        textField.textPadding = configuration.defaultPadding
    }

    func configure(textView: UITextView) {
        textView.font = configuration.font
        textView.textColor = configuration.colors.normal
        textView.tintColor = configuration.tintColor
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.contentOffset = CGPoint(x: 0, y: 0)
        textView.isScrollEnabled = false
    }

    func updateContent(containerState: FieldContainerState) {
        updateTextColor(containerState: containerState)
    }

}

// MARK: - Private Updates

private extension FieldService {

    func updateTextColor(containerState: FieldContainerState) {
        field?.textColor = textColor(containerState: containerState)
    }

}

// MARK: - Private Methods

private extension FieldService {

    func textColor(containerState: FieldContainerState) -> UIColor {
        return configuration.colors.suitableColor(state: containerState)
    }

}
