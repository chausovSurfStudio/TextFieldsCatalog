//
//  DatePickerView.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 12/05/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

/// Custom input view for text fields with UIDatePicker.
/// Have date picker and top view with custom "return" button.
/// You have to provide linked textField in init method, then string with date will set in textField automatically.
public final class DatePickerView: UIView {

    // MARK: - Constants

    private enum Constants {
        static let topViewHeight: CGFloat = 47
    }

    // MARK: - Properties

    public let datePicker = UIDatePicker()
    public var topViewConfiguration = PickerTopViewConfiguration() {
        didSet {
            topView?.configuration = topViewConfiguration
        }
    }

    // MARK: - Private Properties

    private weak var textField: DateTextField? {
        didSet {
            topView?.guidedField = textField
        }
    }
    private var dateFormat = "dd.MM.yyyy"
    private var topView: PickerTopView?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Method for creating DatePickerView with specific size, linked textField and custom dateFormat ("dd.MM.yyyy" by default)
    static public func view(size: CGSize,
                            textField: DateTextField,
                            dateFormat: String? = nil) -> DatePickerView {
        let view = DatePickerView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.textField = textField
        if let dateFormat = dateFormat {
            view.dateFormat = dateFormat
        }
        view.topView?.updateNavigationButtons()
        return view
    }

}

// MARK: - Configure

private extension DatePickerView {

    func configureAppearance() {
        configureDatePicker()
        configureTopView()
    }

    func configureDatePicker() {
        guard bounds.height > Constants.topViewHeight else {
            fatalError("Height of DatePickerView must be more than 47 points (height of topView)")
        }
        let datePickerFrame = CGRect(x: 0,
                                     y: Constants.topViewHeight,
                                     width: bounds.width,
                                     height: bounds.height - Constants.topViewHeight)
        datePicker.frame = datePickerFrame
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.date = Date(timeIntervalSince1970: 0)
        datePicker.addTarget(self, action: #selector(dateChanged(picker:)), for: .valueChanged)
        addSubview(datePicker)
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

// MARK: - Actions

private extension DatePickerView {

    @objc
    func dateChanged(picker: UIDatePicker) {
        let date = picker.date
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        textField?.processDateChange(date, text: formatter.string(from: date))
    }

}
