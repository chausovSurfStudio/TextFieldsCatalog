//
//  MainTab.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit

enum MainTab: Int, CaseIterable {

    case catalog
    case example
    case info

    // MARK: - Properties

    var image: UIImage {
        switch self {
        case .catalog:
            return UIImage(asset: Asset.MainTab.catalog)
        case .example:
            return UIImage(asset: Asset.MainTab.example)
        case .info:
            return UIImage(asset: Asset.MainTab.info)
        }
    }

    var selectedImage: UIImage {
        return image
    }

    var title: String {
        switch self {
        case .catalog:
            return L10n.Constants.MainTab.catalog
        case .example:
            return L10n.Constants.MainTab.example
        case .info:
            return L10n.Constants.MainTab.info
        }
    }

    var navigationController: UINavigationController {
        return CommonNavigationController()
    }

}
