//
//  PlainPickerView.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 13/05/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

/// Custom input view for text fields with UIPickerView.
/// Have picker view and top view with custom "return" button.
/// You have to provide 'data' in init method for configure dataSource of pickerView.
/// You have to provide linked textField in init method, then string with selected value will set in textField automatically.
public final class PlainPickerView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let topViewHeight: CGFloat = 47
        static let rowHeight: CGFloat = 34
    }

    // MARK: - Properties

    public let picker = UIPickerView()
    public var topViewConfiguration = PickerTopViewConfiguration() {
        didSet {
            topView?.configuration = topViewConfiguration
        }
    }

    // MARK: - Private Properties

    private weak var textField: PickerTextField? {
        didSet {
            topView?.textField = textField
        }
    }
    private var data: [String] = []
    private var topView: PickerTopView?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Method for creating PlainPickerView with specific size, linked textField and custom data
    static public func view(size: CGSize,
                            textField: PickerTextField,
                            data: [String]) -> PlainPickerView {
        let view = PlainPickerView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.textField = textField
        view.data = data
        view.picker.reloadAllComponents()
        view.topView?.updateNavigationButtons()
        return view
    }

}

// MARK: - Configure

private extension PlainPickerView {

    func configureAppearance() {
        configurePicker()
        configureTopView()
    }

    func configurePicker() {
        guard bounds.height > Constants.topViewHeight else {
            fatalError("Height of PlainPickerView must be more than 47 points (height of topView)")
        }
        let pickerFrame = CGRect(x: 0,
                                 y: Constants.topViewHeight,
                                 width: bounds.width,
                                 height: bounds.height - Constants.topViewHeight)
        picker.frame = pickerFrame
        picker.delegate = self
        picker.dataSource = self
        addSubview(picker)
    }

    func configureTopView() {
        let topView = PickerTopView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: bounds.width,
                                                  height: Constants.topViewHeight))
        self.topView = topView
        addSubview(topView)
    }

}

// MARK: - UIPickerViewDataSource

extension PlainPickerView: UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }

}

// MARK: - UIPickerViewDelegate

extension PlainPickerView: UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Constants.rowHeight
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField?.processValueChange(data[row])
    }

}
