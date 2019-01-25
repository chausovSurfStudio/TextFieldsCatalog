//
//  UIViewController.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 25/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

/// Style for navigation bar buttons
enum NavigationBarButtonStyle {
    case close
    case info
    case text(String)

    func image() -> UIImage? {
        switch self {
        case .close:
            return UIImage(asset: Asset.close)
        case .info:
            return UIImage(asset: Asset.info)
        case .text(_):
            return nil
        }
    }
}

extension UIViewController {

    /// Method allows you to add left bar button and set selector for it
    @discardableResult
    func addLeftBarButton(_ style: NavigationBarButtonStyle, selector: Selector?) -> UIBarButtonItem {
        switch style {
        case .close, .info:
            let leftBarButtonItem = UIBarButtonItem(image: style.image(),
                                                    style: .plain,
                                                    target: self,
                                                    action: selector)
            navigationItem.leftBarButtonItem = leftBarButtonItem
            return leftBarButtonItem
        case .text(let text):
            let leftBarButtonItem = UIBarButtonItem(title: text,
                                                    style: .plain,
                                                    target: self,
                                                    action: selector)
            navigationItem.leftBarButtonItem = leftBarButtonItem
            return leftBarButtonItem
        }
    }

    /// Method allows you to add right bar button and set selector for it
    @discardableResult
    func addRightBarButton(_ style: NavigationBarButtonStyle, selector: Selector?) -> UIBarButtonItem {
        switch style {
        case .close, .info:
            let rightBarButtonItem = UIBarButtonItem(image: style.image(),
                                                     style: .plain,
                                                     target: self,
                                                     action: selector)
            navigationItem.rightBarButtonItem = rightBarButtonItem
            return rightBarButtonItem
        case .text(let text):
            let rightBarButtonItem = UIBarButtonItem(title: text,
                                                     style: .plain,
                                                     target: self,
                                                     action: selector)
            navigationItem.rightBarButtonItem = rightBarButtonItem
            return rightBarButtonItem
        }
    }

}
