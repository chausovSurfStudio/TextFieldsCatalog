//
//  UIView.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 17.01.2021.
//  Copyright © 2021 Александр Чаусов. All rights reserved.
//

import UIKit

extension UIView {

    func stretch(_ subview: UIView, translatesAutoresizingMaskIntoConstraints: Bool = false) {
        subview.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints

        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: self.topAnchor),
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

}
