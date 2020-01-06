//
//  MainTabBarViewController.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import UIKit

final class MainTabBarViewController: UITabBarController {

    // MARK: - Properties

    var output: MainTabBarViewOutput?

    // MARK: - Private Properties

    private var isSelectableStackEmpty: Bool = true

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        configureAppearance()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configureAppearance()
    }

}

// MARK: - MainTabBarViewInput

extension MainTabBarViewController: MainTabBarViewInput {

    func selectTab(_ tab: MainTab) {
        guard
            let view = viewControllers?[safe: tab.rawValue],
            tabBarController(self, shouldSelect: view) else {
                return
        }
        selectedIndex = tab.rawValue
        tabBarController(self, didSelect: view)
    }

}

// MARK: - UITabBarControllerDelegate

extension MainTabBarViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let navigationController = viewController as? UINavigationController
        var isStackEmpty = true
        if let isEmpty = navigationController?.viewControllers.isEmpty, !isEmpty {
            isStackEmpty = navigationController?.visibleViewController == navigationController?.viewControllers[0]
        }
        isSelectableStackEmpty = isStackEmpty
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tab = MainTab(rawValue: viewController.tabBarItem.tag) else {
            return
        }
        let navigationController = viewController as? UINavigationController
        let isInitial = navigationController?.viewControllers.isEmpty ?? true
        output?.selectTab(with: tab, isInitial: isInitial, isStackEmpty: isSelectableStackEmpty)
    }

}

// MARK: - Appearance

private extension MainTabBarViewController {

    func configureAppearance() {
        let backgroundImage = UIImage(color: Color.TabBar.background)
        let shadowImage = UIImage(color: Color.TabBar.separator)
        if #available(iOS 13, *) {
            let appearance = tabBar.standardAppearance.copy()
            appearance.backgroundImage = backgroundImage
            appearance.shadowImage = shadowImage
            appearance.stackedLayoutAppearance.normal.iconColor = Color.TabBar.itemTint
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.TabBar.itemTint]
            appearance.stackedLayoutAppearance.selected.iconColor = Color.TabBar.selectedItemTint
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.TabBar.selectedItemTint]
            tabBar.standardAppearance = appearance
        } else {
            tabBar.backgroundImage = backgroundImage
            tabBar.shadowImage = shadowImage
            tabBar.tintColor = Color.TabBar.selectedItemTint
            tabBar.unselectedItemTintColor = Color.TabBar.itemTint
        }
    }

}
