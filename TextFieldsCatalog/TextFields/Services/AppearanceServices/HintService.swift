//
//  HintService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 05.01.2021.
//  Copyright © 2021 Александр Чаусов. All rights reserved.
//

import UIKit

public class HintService: AbstractHintService {

    // MARK: - Private Properties

    private let configuration: HintConfiguration
    private var visibleHintStates: HintVisibleStates
    private var hintLabel: UILabel?
    private var hintMessage: String?

    // MARK: - Initialization

    public init(configuration: HintConfiguration,
                visibleHintStates: HintVisibleStates = [.error, .active]) {
        self.configuration = configuration
        self.visibleHintStates = visibleHintStates
    }

    // MARK: - AbstractHintService

    public func provide(label: UILabel) {
        self.hintLabel = label
    }

    public func configureAppearance() {
        hintLabel?.textColor = configuration.colors.normal
        hintLabel?.font = configuration.font
        hintLabel?.text = ""
        hintLabel?.numberOfLines = 0
        hintLabel?.alpha = 0
    }

    public func updateContent(containerState: FieldContainerState,
                              heightLayoutPolicy: HeightLayoutPolicy) {
        updateHintLabelColor(containerState: containerState)
        updateHintLabelVisibility(containerState: containerState,
                                  heightLayoutPolicy: heightLayoutPolicy)
    }

    public func hintHeight(containerState: FieldContainerState) -> CGFloat {
        guard
            let label = hintLabel,
            let hint = label.text,
            !hint.isEmpty,
            shouldShowHint(containerState: containerState)
        else {
            return 0
        }
        return hint.height(forWidth: label.bounds.size.width,
                           font: configuration.font,
                           lineHeight: configuration.lineHeight)
    }

    public func setup(plainHint: String?) {
        self.hintMessage = plainHint
        setup(hintText: plainHint)
    }

    public func setup(errorHint: String?) {
        guard let text = errorHint else {
            return
        }
        setup(hintText: text)
    }

    public func showHint() {
        setup(hintText: hintMessage)
    }

    public func setup(visibleHintStates: HintVisibleStates) {
        self.visibleHintStates = visibleHintStates
    }

}

// MARK: - Private Updates

private extension HintService {

    func updateHintLabelColor(containerState: FieldContainerState) {
        hintLabel?.textColor = hintTextColor(containerState: containerState)
    }

    func updateHintLabelVisibility(containerState: FieldContainerState,
                                   heightLayoutPolicy: HeightLayoutPolicy) {
        let hintIsVisible = shouldShowHint(containerState: containerState)
        let alpha: CGFloat = hintIsVisible ? 1 : 0
        var duration: TimeInterval = AnimationTime.default
        switch heightLayoutPolicy {
        case .fixed:
            // update always with animation
            break
        case .elastic:
            // update with animation on hint appear
            duration = hintIsVisible ? AnimationTime.default : 0
        }
        UIView.animate(withDuration: duration) { [weak self] in
            self?.hintLabel?.alpha = alpha
        }
    }

}

// MARK: - Private Methods

private extension HintService {

    func setup(hintText: String?) {
        let text = hintText ?? ""
        hintLabel?.attributedText = text.with(lineHeight: configuration.lineHeight,
                                              font: configuration.font,
                                              color: hintLabel?.textColor ?? UIColor.black)
    }

    func hintTextColor(containerState: FieldContainerState) -> UIColor {
        return configuration.colors.suitableColor(state: containerState)
    }

    func shouldShowHint(containerState: FieldContainerState) -> Bool {
        guard !(hintLabel?.text?.isEmpty ?? true) else {
            return false
        }
        switch containerState {
        case .error:
            return visibleHintStates.contains(.error)
        case .disabled:
            return visibleHintStates.contains(.disabled)
        case .normal:
            return visibleHintStates.contains(.normal)
        case .active:
            return visibleHintStates.contains(.active)
        }
    }

}
