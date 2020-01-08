//
//  HintService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 08/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

final class HintService {

    // MARK: - Constants

    private enum Constants {
        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - Private Properties

    private let hintLabel: UILabel

    private var configuration: HintConfiguration
    private var hintMessage: String?
    private var heightLayoutPolicy: HeightLayoutPolicy

    // MARK: - Initialization

    init(hintLabel: UILabel,
         configuration: HintConfiguration,
         heightLayoutPolicy: HeightLayoutPolicy) {
        self.hintLabel = hintLabel
        self.configuration = configuration
        self.hintMessage = nil
        self.heightLayoutPolicy = heightLayoutPolicy
    }

    // MARK: - Internal Methods

    func setup(configuration: HintConfiguration) {
        self.configuration = configuration
    }

    func setup(hintMessage: String?) {
        self.hintMessage = hintMessage
    }

    func setup(heightLayoutPolicy: HeightLayoutPolicy) {
        self.heightLayoutPolicy = heightLayoutPolicy
    }

    func configureHintLabel() {
        hintLabel.textColor = configuration.colors.normal
        hintLabel.font = configuration.font
        hintLabel.text = ""
        hintLabel.numberOfLines = 0
        hintLabel.alpha = 0
    }

    func updateHintLabelColor(containerState: FieldContainerState) {
        hintLabel.textColor = hintTextColor(containerState: containerState)
    }

    func updateHintLabelVisibility(containerState: FieldContainerState) {
        let hintIsVisible = shouldShowHint(containerState: containerState)
        let alpha: CGFloat = hintIsVisible ? 1 : 0
        var duration: TimeInterval = Constants.animationDuration
        switch heightLayoutPolicy {
        case .fixed:
            // update always with animation
            break
        case .flexible(_, _):
            // update with animation on hint appear
            duration = hintIsVisible ? Constants.animationDuration : 0
        }
        UIView.animate(withDuration: duration) { [weak self] in
            self?.hintLabel.alpha = alpha
        }
    }

    func setupHintText(_ hintText: String) {
        hintLabel.attributedText = hintText.with(lineHeight: configuration.lineHeight,
                                                 font: configuration.font,
                                                 color: hintLabel.textColor)
    }

    func setupHintIfNeeded() {
        setupHintText(hintMessage ?? "")
    }

    func hintLabelHeight(containerState: FieldContainerState) -> CGFloat {
        guard
            let hint = hintLabel.text,
            !hint.isEmpty,
            shouldShowHint(containerState: containerState)
        else {
            return 0
        }
        return hint.height(forWidth: hintLabel.bounds.size.width,
                           font: configuration.font,
                           lineHeight: configuration.lineHeight)
    }

}

// MARK: - Private Methods

private extension HintService {

    func hintTextColor(containerState: FieldContainerState) -> UIColor {
        return configuration.colors.suitableColor(state: containerState)
    }

    func shouldShowHint(containerState: FieldContainerState) -> Bool {
        switch containerState {
        case .error:
            return true
        case .disabled, .normal:
            return false
        case .active:
            return hintMessage != nil
        }
    }

}
