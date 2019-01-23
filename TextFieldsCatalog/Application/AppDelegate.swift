//
//  AppDelegate.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Private Properties

    private lazy var applicationCoordinator: Coordinator = self.makeCoordinator()

    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeRootView()
        applicationCoordinator.start()
        return true
    }

}

// MARK: - Private Methods

private extension AppDelegate {

    private func initializeRootView() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
    }

    private func makeCoordinator() -> Coordinator {
        return ApplicationCoordinator()
    }

}
