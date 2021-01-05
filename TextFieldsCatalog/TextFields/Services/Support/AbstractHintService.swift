//
//  AbstractHintService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 05.01.2021.
//  Copyright © 2021 Александр Чаусов. All rights reserved.
//

import UIKit

/**
 Abstract protocl for hint service.

 You can use existed `HintService` from this library, this service will do all work for supporting hint messages,
 or you can provide your own service which have to implement this protocol.
 */
public protocol AbstractHintService {
    /**
     This method provides your service with a label, where you have to place hint message
     */
    func provide(label: UILabel)
    /**
     Method where you have to setup initial state for hint label
     */
    func configureAppearance()
    /**
     Method invokes when field wants to update UI elements.
     You have to update visibility of you hint, it's color, etc.
     */
    func updateContent(containerState: FieldContainerState, heightLayoutPolicy: HeightLayoutPolicy)
    /**
     Method allows to calculate current hint message height,
     or returns zero if hint message doesn't exist or invisible
     */
    func hintHeight(containerState: FieldContainerState) -> CGFloat

    /**
     Method allows setup hint message
     */
    func setup(plainHint: String?)
    /**
     Method allows setup error hint message.

     If errorHint is nil - you have to save previous plain hint message in label, if it exists.
     */
    func setup(errorHint: String?)
    /**
     Method to drop all error hint messages and present plain hint, if it exists.
     */
    func showHint()
    /**
     Service method, which allows you to change current visible hint states.
     */
    func setup(visibleHintStates: HintVisibleStates)

}
