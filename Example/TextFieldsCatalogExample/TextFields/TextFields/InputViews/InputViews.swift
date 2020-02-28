//
//  InputViews.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 11/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit
import TextFieldsCatalog

fileprivate enum Constants {
    static let inputViewHeight: CGFloat = 261
}

extension DatePickerView {

    /// Default configuration for inputView with UIDatePicker
    static func `default`(for textField: DateTextField) -> DatePickerView {
        let viewSize = CGSize(width: UIScreen.main.bounds.width,
                              height: Constants.inputViewHeight)
        let view = DatePickerView.view(size: viewSize, textField: textField)
        view.datePicker.backgroundColor = Color.Main.container
        view.topViewConfiguration = PickerTopViewConfiguration.default()
        return view
    }

}

extension PlainPickerView {

    /// Default configuration for inputView with UIPickerView
    static func `default`(for textField: PickerTextField, data: [String]) -> PlainPickerView {
        let viewSize = CGSize(width: UIScreen.main.bounds.width,
                              height: Constants.inputViewHeight)
        let view = PlainPickerView.view(size: viewSize,
                                        textField: textField,
                                        data: data)
        view.picker.backgroundColor = Color.Main.container
        view.topViewConfiguration = PickerTopViewConfiguration.default()
        return view
    }

}

private extension PickerTopViewConfiguration {

    /// Default configuration for inputView's toolbars
    static func `default`() -> PickerTopViewConfiguration {
        let buttonsConfiguration = PickerTopViewButtonConfiguration(text: L10n.Button.done,
                                                                    activeColor: Color.Button.active,
                                                                    highlightedColor: Color.Button.pressed)
        return PickerTopViewConfiguration(backgroundColor: Color.Main.container,
                                          separatorsColor: UIColor.clear,
                                          button: buttonsConfiguration)
    }

}
