//
//  AbstractHintService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 05.01.2021.
//  Copyright © 2021 Александр Чаусов. All rights reserved.
//

import UIKit

public protocol AbstractHintService {

    func provide(label: UILabel)
    func configureAppearance()
    func updateContent(containerState: FieldContainerState, heightLayoutPolicy: HeightLayoutPolicy)
    func hintHeight(containerState: FieldContainerState) -> CGFloat

    func setup(plainHint: String?)
    func setup(errorHint: String?)
    func showHint()

}
