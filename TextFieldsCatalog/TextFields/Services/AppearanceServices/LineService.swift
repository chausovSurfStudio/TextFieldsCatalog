//
//  LineService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 08/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

final class LineService {

    // MARK: - Nested Types

    enum LineUpdateStrategy {
        case height
        case frame
    }

    // MARK: - Private Properties

    private let lineView = UIView()
    private let superview: InnerDesignableView
    private let field: InputField?
    private let flexibleTopSpace: Bool

    private var configuration: LineConfiguration
    private var lastLinePosition: CGRect = .zero

    // MARK: - Initialization

    init(superview: InnerDesignableView,
         field: InputField?,
         flexibleTopSpace: Bool,
         configuration: LineConfiguration) {
        self.superview = superview
        self.field = field
        self.flexibleTopSpace = flexibleTopSpace
        self.configuration = configuration
    }

    // MARK: - Internal Methods

    func setup(configuration: LineConfiguration) {
        self.configuration = configuration
    }

    func configureLineView(fieldState: FieldState) {
        let superview = configuration.superview ?? self.superview.view
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
                       strategy: LineUpdateStrategy) {
        updateLineViewColor(containerState: containerState)
        switch strategy {
        case .height:
            updateLineViewHeight(fieldState: fieldState)
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
        superview.view.layoutIfNeeded()
    }

}

// MARK: - Private Updates

private extension LineService {

    func updateLineViewColor(containerState: FieldContainerState) {
        let color = lineColor(containerState: containerState)
        UIView.animate(withDuration: AnimationTime.default) { [weak self] in
            self?.lineView.backgroundColor = color
        }
    }

    func updateLineViewHeight(fieldState: FieldState) {
        let height = lineHeight(fieldState: fieldState)
        UIView.animate(withDuration: AnimationTime.default) { [weak self] in
            self?.lineView.frame.size.height = height
        }
    }

}

// MARK: - Private Methods

private extension LineService {

    func lineColor(containerState: FieldContainerState) -> UIColor {
        return configuration.colors.suitableColor(state: containerState)
    }

    func linePosition(fieldState: FieldState) -> CGRect {
        let height = lineHeight(fieldState: fieldState)
        let superview = configuration.superview ?? self.superview.view
        var lineFrame = superview.bounds.inset(by: configuration.insets)
        lineFrame.size.height = height
        if flexibleTopSpace {
            lineFrame.origin.y = 5 + (field?.frame.maxY ?? 0)
        }
        return lineFrame
    }

    func lineHeight(fieldState: FieldState) -> CGFloat {
        return fieldState == .active ? configuration.increasedHeight : configuration.defaultHeight
    }

}
