//
//  MainRouter.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import SPStorkController

/// Provides methods and properties for all navigation operations.
/// Instantiate, and use the object of this class in coordinators.
class MainRouter: Router {

    private var window: UIWindow? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window
    }

    private var navigationController: UINavigationController? {
        if let tabBar = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            return tabBar.selectedViewController as? UINavigationController
        }
        return UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
    }

    private var tabBarController: UITabBarController? {
        return UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
    }

    private var topViewController: UIViewController? {
        return UIApplication.topViewController()
    }

    func present(_ module: Presentable?) {
        self.present(module, animated: true, completion: nil)
    }

    func present(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        guard let controller = module?.toPresent() else {
            return
        }
        if let storkContainer = controller as? StorkContainerViewController, !UIDevice.isAvailableIos13 {
            let delegate = storkTransitionDelegate()
            storkContainer.transitioningDelegate = delegate
            storkContainer.modalPresentationStyle = .custom
            storkContainer.modalPresentationCapturesStatusBarAppearance = true
            self.topViewController?.present(storkContainer, animated: animated, completion: completion)
        } else {
            self.topViewController?.present(controller, animated: animated, completion: completion)
        }
    }

    func push(_ module: Presentable?) {
        self.push(module, animated: true)
    }

    func push(_ module: Presentable?, animated: Bool) {
        if let controller = module?.toPresent() {
            self.topViewController?.navigationController?.pushViewController(controller, animated: animated)
        }
    }

    func popModule() {
        self.popModule(animated: true)
    }

    func popModule(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }

    func popPreviousView() {
        guard var controllers = self.navigationController?.viewControllers, controllers.count >= 3 else {
            return
        }
        controllers.remove(at: controllers.count - 2)
        self.navigationController?.viewControllers = controllers
    }

    func dismissModule() {
        self.dismissModule(animated: true, completion: nil)
    }

    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        topViewController?.dismiss(animated: animated, completion: completion)
    }

    func setNavigationControllerRootModule(_ module: Presentable?, animated: Bool = false, hideBar: Bool = false) {
        if let controller = module?.toPresent() {
            navigationController?.isNavigationBarHidden = hideBar
            navigationController?.setViewControllers([controller], animated: false)
        }
    }

    func setRootModule(_ module: Presentable?) {
        window?.rootViewController = module?.toPresent()
    }

    func setTab(_ index: Int) {
        tabBarController?.selectedIndex = index
    }
}

// MARK: - SPStorkController Support

private extension MainRouter {

    func storkTransitionDelegate() -> SPStorkTransitioningDelegate {
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.showIndicator = false
        return transitionDelegate
    }

}
