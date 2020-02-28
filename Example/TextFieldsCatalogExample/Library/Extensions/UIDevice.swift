//
//  UIDevice.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 07/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit

extension UIDevice {

    /// Returns 'true' if iOS 13 is available
    static var isAvailableIos13: Bool {
        if #available(iOS 13.0, *) {
            return true
        } else {
            return false
        }
    }

}
