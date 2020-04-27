//
//  AbstractPlaceholderService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 27/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

protocol AbstractPlaceholderService {

    // MARK: - Properties

    var useIncreasedRightPadding: Bool { get set }

    // MARK: - Methods

    func setup(placeholder: String?)

    func configurePlaceholder(fieldState: FieldState, containerState: FieldContainerState)

    func updateContent(fieldState: FieldState,
                       containerState: FieldContainerState)

    func updatePlaceholderFrame(fieldState: FieldState)

}
