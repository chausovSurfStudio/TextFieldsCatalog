//
//  CommonNavigationController.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

/// Default navigation controller in application with customized bar
final class CommonNavigationController: UINavigationController {

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        self.delegate = self
    }

}

// MARK: - Private Methods

private extension CommonNavigationController {

    func configureAppearance() {
        navigationBar.barTintColor = Color.NavBar.background
        navigationBar.tintColor = Color.NavBar.tint
        navigationBar.titleTextAttributes = [.foregroundColor: Color.NavBar.text,
                                             .font: UIFont.systemFont(ofSize: 17, weight: .medium)]
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.isTranslucent = false
    }

}

// MARK: - UINavigationControllerDelegate

extension CommonNavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // removing "Back" word from back navigation bar button
        navigationController.topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

}
