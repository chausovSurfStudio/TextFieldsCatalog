//
//  AbstractPlaceholderService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 27/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

public protocol AbstractPlaceholderService {

    // MARK: - Methods

    func provide(superview: UIView, field: InputField?)

    func setup(placeholder: String?)

    func configurePlaceholder(fieldState: FieldState, containerState: FieldContainerState)

    func updateContent(fieldState: FieldState,
                       containerState: FieldContainerState)

    // optional method
    func setup(configuration: Any)

    // optional method
    func update(useIncreasedRightPadding: Bool, fieldState: FieldState)

    // optional method
    func updateAfterTextChanged(fieldState: FieldState)

}

extension AbstractPlaceholderService {

    public func setup(configuration: Any) {}

    public func update(useIncreasedRightPadding: Bool, fieldState: FieldState) {}

    public func updateAfterTextChanged(fieldState: FieldState) {}

}
