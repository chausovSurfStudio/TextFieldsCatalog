//
//  LineService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 08/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit

final class LineService {

    // MARK: - Nested Types

    enum LineUpdateStrategy {
        case height
        case frame
    }

    // MARK: - Private Properties

    private let lineView = UIView()
    private weak var superview: InnerDesignableView?
    private weak var field: InputField?

    private var configuration: LineConfiguration
    private var lastLinePosition: CGRect = .zero

    // MARK: - Initialization

    init(superview: InnerDesignableView,
         field: InputField?,
         configuration: LineConfiguration) {
        self.superview = superview
        self.field = field
        self.configuration = configuration
    }

    // MARK: - Internal Methods

    func setup(configuration: LineConfiguration) {
        self.configuration = configuration
    }

    func configureLineView(fieldState: FieldState) {
        guard let superview = configuration.superview ?? self.superview?.view else {
            return
        }
        if lineView.superview == nil || lineView.superview != superview {
            lineView.removeFromSuperview()
            superview.addSubview(lineView)
        }
        lineView.frame = linePosition(fieldState: fieldState)
        lineView.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth]
        lineView.layer.cornerRadius = configuration.cornerRadius
        lineView.layer.masksToBounds = true
        lineView.backgroundColor = configuration.colors.normal
        lastLinePosition = lineView.frame
    }

    func updateContent(fieldState: FieldState,
                       containerState: FieldContainerState,
                       strategy: LineUpdateStrategy,
                       animated: Bool) {
        updateLineViewColor(containerState: containerState, animated: animated)
        switch strategy {
        case .height:
            updateLineViewHeight(fieldState: fieldState, animated: animated)
        case .frame:
            updateLineFrame(fieldState: fieldState)
        }
    }

    func updateLineFrame(fieldState: FieldState) {
        let actualPosition = linePosition(fieldState: fieldState)
        guard lastLinePosition != actualPosition else {
            return
        }
        lastLinePosition = actualPosition
        lineView.frame = actualPosition
        superview?.view.layoutIfNeeded()
    }

}

// MARK: - Private Updates

private extension LineService {

    func updateLineViewColor(containerState: FieldContainerState, animated: Bool) {
        let color = lineColor(containerState: containerState)
        let animationBlock: () -> Void = {
            self.lineView.backgroundColor = color
        }
        if animated {
            UIView.animate(withDuration: AnimationTime.default, animations: animationBlock)
        } else {
            animationBlock()
        }
    }

    func updateLineViewHeight(fieldState: FieldState, animated: Bool) {
        let height = lineHeight(fieldState: fieldState)
        let animationBlock: () -> Void = {
            self.lineView.frame.size.height = height
        }
        if animated {
            UIView.animate(withDuration: AnimationTime.default, animations: animationBlock)
        } else {
            animationBlock()
        }

    }

}

// MARK: - Private Methods

private extension LineService {

    func lineColor(containerState: FieldContainerState) -> UIColor {
        return configuration.colors.suitableColor(state: containerState)
    }

    func linePosition(fieldState: FieldState) -> CGRect {
        guard
            let superview = configuration.superview ?? self.superview?.view,
            let field = field
        else {
            return .zero
        }
        let height = lineHeight(fieldState: fieldState)
        var lineFrame = superview.bounds.inset(by: configuration.insets)
        lineFrame.size.height = height

        let relativeFieldFrame = superview.convert(field.frame, to: superview)
        lineFrame.origin.y = configuration.insets.top + relativeFieldFrame.maxY
        return lineFrame
    }

    func lineHeight(fieldState: FieldState) -> CGFloat {
        return fieldState == .active ? configuration.increasedHeight : configuration.defaultHeight
    }

}
