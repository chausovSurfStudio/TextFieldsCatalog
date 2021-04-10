//
//  AbstractPlaceholderService.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 27/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit

/**
 Protocol for abstract service, which contains logic for drawing placeholder.

 This protocol have main methods to draw placeholder as you want. Some methods is optional.

 If you want to use you own custom placeholder service - you may implement service with this protocol.
 */
public protocol AbstractPlaceholderService {

    // MARK: - Methods

    /**
     Method setups input field (textField or textView) with superview on your placeholder.

     In this method you can add you placeholder container (eg UILabel or CATextLayer) on superview or handle weak link on you field/superview.

     - Parameters:
        - superview: View where you have to place you placeholder
        - field: TextField/TextView where user will be enter some text
     - Important: Method will call on
        - field initialization
        - configuration refresh
        - or when you add service to your field
     */
    func provide(superview: UIView, field: InputField?)

    /**
     Method allows you to setup some string in your placeholder.

     In this method you have to setup placeholder string in placeholder container.

     - Parameters:
        - placeholder: String for placeholder
     - Important: The only place where method will be called from frameworks field - is
        ```
        func configure(placeholder: String?)
        ```
        method. If you have more than one placeholder service - you have to provide string yourself.
    */
    func setup(placeholder: String?)

    /**
     Method allows you to configure placeholder initial state.

     - Parameters:
        - fieldState: State of field
        - containerState: State of field container (have more states compared with fieldState)
     - Important: This method will be called on
        - field initialization
        - and when you add service to your field
    */
    func configurePlaceholder(fieldState: FieldState, containerState: FieldContainerState)

    /**
     Method allows you to configure placeholder for appropriate state.

     This is main method where you have to place logic for placeholder state refreshing.

     - Parameters:
        - fieldState: State of field
        - containerState: State of field container (have more states compared with fieldState)
     - Important: This method will be called on
        - field initialization
        - and when UI have some significant changes (eg user enter text, error occured, etc)
    */
    func updateContent(fieldState: FieldState,
                       containerState: FieldContainerState,
                       animated: Bool)

    /**
     This method will be called when you add/remove additional action button.

     In this method you have to place logic for refreshing placeholder frame, so that it does not overlap the button.

     - Parameters:
        - useIncreasedRightPadding: Flag indicating whether you should use increased right padding for your placeholder (if action button is visible) or not
        - fieldState: State of field
     - Important: This is optional method. You can leave it empty if you doesn't use action button or if you placeholder never overlap it.
    */
    func update(useIncreasedRightPadding: Bool,
                fieldState: FieldState,
                animated: Bool)

    /**
     This method will be called when user enter some text in field, but state of field doesn't changed.

     - Parameters:
        - fieldState: State of field
     - Important: This is optional method. You can leave it empty if you don't need to such logic.
    */
    func updateAfterTextChanged(fieldState: FieldState)

}

extension AbstractPlaceholderService {

    public func update(useIncreasedRightPadding: Bool,
                       fieldState: FieldState,
                       animated: Bool) {}

    public func updateAfterTextChanged(fieldState: FieldState) {}

}
