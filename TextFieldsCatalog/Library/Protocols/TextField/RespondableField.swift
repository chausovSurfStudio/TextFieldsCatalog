//
//  RespondableField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 22/05/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

/**
 Abstract protocol that give you ability to control under responder chain for text fields.
 */
public protocol RespondableField {
    /**
     Next responder, next field which will be activated with `next` button on keyboard or toolbar.

     You can setup any UIResponder object and it will be activated when user tap on `next` keyboard button.

     - Important:
        - When you setup non-nill object - your `returnKeyType` will set with `.next` value.
        - If you provide nill object - `returnKeyType` will set with `.default` value.
        - This rules doesn't apply into the TextView.
        - This property will be used separatly for your needs, but also it can be used with picker views from library (which have custom toolbar view with next/previous arrow buttons).
     */
    var nextInput: UIResponder? { get set }
    /**
     Previous responder, previous field which will be activated with `previous` button on custom tollbar view from this library.

     Originally, this property is useless, because default keyboard doesn't have any button for switching on previous field. But you can use this property for your custom toolbar or predefined toolbar from this library.
    */
    var previousInput: UIResponder? { get set }
    /// Returns a Boolean value indicating whether this object is the first responder.
    var isFirstResponder: Bool { get }

    /// Asks UIKit to make this object the first responder in its window.
    func becomeFirstResponder() -> Bool
}
