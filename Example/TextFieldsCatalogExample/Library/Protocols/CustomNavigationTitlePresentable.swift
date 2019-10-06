//
//  CustomNavigationTitlePresentable.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

private enum CustomNavigationTitleConstants {
    /// Space between label with large title in scroll view and top safe area
    static let topOffset: CGFloat = 10
    /// Space between label with large title and left/right side of superview
    static let horizontalOffset: CGFloat = 32
}

/// Protocol with default implementation for UIViewController for showing the dissappearing navigation title
protocol CustomNavigationTitlePresentable {
    /// Custom navigation title
    var navigationTitle: CustomTitleView? { get }
    /// Method allows you to configure custom navigation title with passed title
    func configureNavigationTitle(with title: String)
    /// Method allows you to update state of custom navigation title for current scroll view offset
    func updateNavigationTitle(for offset: CGFloat)
}

extension CustomNavigationTitlePresentable where Self: UIViewController {

    var navigationTitle: CustomTitleView? {
        return navigationItem.titleView as? CustomTitleView
    }

    func configureNavigationTitle(with title: String) {
        let titleView = CustomTitleView()
        let navTitleHeight = title.height(forWidth: (UIScreen.main.bounds.width - CustomNavigationTitleConstants.horizontalOffset),
                                          attributes: attributesForTitle())
        let threshold = navTitleHeight + CustomNavigationTitleConstants.topOffset
        titleView.configure(with: title, titleColor: Color.NavBar.text)
        titleView.updateThreshold(threshold)
        navigationItem.titleView = titleView
    }

    func updateNavigationTitle(for offset: CGFloat) {
        navigationTitle?.updateForContentOffset(offset)
    }

    // MARK: - Private Methods

    private func attributesForTitle() -> [NSAttributedString.Key: Any] {
        let font = UIFont.systemFont(ofSize: 34, weight: .bold)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 41 - font.lineHeight

        return [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
    }

}
