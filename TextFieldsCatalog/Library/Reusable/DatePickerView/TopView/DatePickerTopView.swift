//
//  DatePickerTopView.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 12/05/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

final class DatePickerTopView: InnerDesignableView {

    // MARK: - IBOutlets

    @IBOutlet private weak var topSeparator: UIView!
    @IBOutlet private weak var bottomSeparator: UIView!
    @IBOutlet private weak var returnButton: CommonButton!

    // MARK: - Initialization

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UIView

    override public func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }

}

// MARK: - Configure

private extension DatePickerTopView {

    func configureAppearance() {
    }

}
