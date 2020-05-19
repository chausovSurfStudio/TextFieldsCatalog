//
//  AbstractPlaceholderService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 27/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

public protocol AbstractPlaceholderService {

    // MARK: - Properties

    var useIncreasedRightPadding: Bool { get set }

    // MARK: - Methods

    func provide(superview: UIView, field: InputField?)

    func setup(configuration: Any)

    func setup(placeholder: String?)

    func configurePlaceholder(fieldState: FieldState, containerState: FieldContainerState)

    func updateContent(fieldState: FieldState,
                       containerState: FieldContainerState)

    // optional method
    func updatePlaceholderFrame(fieldState: FieldState)

    // optional method
    func updatePlaceholderVisibility(fieldState: FieldState)

}

extension AbstractPlaceholderService {

    func updatePlaceholderFrame(fieldState: FieldState) {}

    func updatePlaceholderVisibility(fieldState: FieldState) {}

}
