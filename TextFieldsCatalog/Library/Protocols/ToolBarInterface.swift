//
//  ToolBarInterface.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 09/10/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

/// Abstract protocol for fields input accessory views.
/// You can add buttons to switch between input fields, guidedField will help you with this.
/// Or you can ignore this field and create your own custom toolbar!
public protocol ToolBarInterface: UIView {
    /// Field that allows you to manage responder chain from your views
    var guidedField: GuidedTextField? { get set }
    /// In this method you have to update your toolbars's appearance via field states
    func updateNavigationButtons()
}
