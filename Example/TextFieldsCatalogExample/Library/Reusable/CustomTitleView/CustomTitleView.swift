//
//  CustomTitleView.swift
//  TextFieldsCatalog
//
//  Created by Chausov Alexander on 23/11/2018.
//  Copyright © 2018 Surf. All rights reserved.
//

import UIKit

class CustomTitleView: DesignableView {

    // MARK: - IBOutlets

    @IBOutlet private weak var headerLabel: UILabel!

    // MARK: - Private Properties

    private var threshold: CGFloat = 0

    // MARK: - Internal methods

    func configure(with title: String, titleColor: UIColor) {
        headerLabel.textColor = titleColor
        headerLabel.text = title
        headerLabel.alpha = 0
    }

    func updateThreshold(_ threshold: CGFloat) {
        self.threshold = threshold
    }

    func updateForContentOffset(_ offset: CGFloat) {
        let supposedAlpha: CGFloat = offset > threshold ? 1 : 0
        guard supposedAlpha != headerLabel.alpha else {
            return
        }
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let `self` = self else {
                return
            }
            self.headerLabel.alpha = offset > self.threshold ? 1 : 0
        }
    }

}
