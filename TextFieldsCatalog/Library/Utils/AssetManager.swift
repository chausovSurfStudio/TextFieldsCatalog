//
//  AssetManager.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 29/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation
import UIKit

final class AssetManager {

    func getImage(_ name: String) -> UIImage {
        let traitCollection = UITraitCollection(displayScale: UIScreen.main.scale)
        var bundle: Bundle
        #if SWIFT_PACKAGE
        bundle = Bundle.module
        #else
        bundle = Bundle(for: AssetManager.self)
        #endif
        if let resource = bundle.resourcePath, let resourceBundle = Bundle(path: resource + "/TextFieldsCatalog.bundle") {
            bundle = resourceBundle
        }

        return UIImage(named: name, in: bundle, compatibleWith: traitCollection) ?? UIImage()
    }

}
