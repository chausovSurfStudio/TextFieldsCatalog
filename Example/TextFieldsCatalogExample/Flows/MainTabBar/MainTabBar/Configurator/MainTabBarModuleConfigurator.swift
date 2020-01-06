//
//  MainTabBarModuleConfigurator.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import UIKit

final class MainTabBarModuleConfigurator {

    func configure() -> (UIViewController, MainTabBarModuleOutput) {
        let view = MainTabBarViewController()
        let presenter = MainTabBarPresenter()

        presenter.view = view
        view.output = presenter

        view.viewControllers = configureControllers()

        return (view, presenter)
    }

}

// MARK: - Private Methods

private extension MainTabBarModuleConfigurator {

    func configureControllers() -> [UIViewController] {
        var controllers: [UIViewController] = []
        for tab in MainTab.allCases {
            let tabBarItem = UITabBarItem(title: tab.title,
                                          image: tab.image,
                                          selectedImage: tab.selectedImage)
            tabBarItem.tag = tab.rawValue

            let navigationController = tab.navigationController
            navigationController.tabBarItem = tabBarItem
            controllers.append(navigationController)
        }
        return controllers
    }

}
