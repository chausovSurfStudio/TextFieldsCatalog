//
//  ApplicationCoordinator.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

final class ApplicationCoordinator: BaseCoordinator {

    // MARK: - Coordinator

    override func start(with deepLinkOption: DeepLinkOption?) {
        runMainTabBarFlow()
    }

}

// MARK: - Private Methods

private extension ApplicationCoordinator {

    func runMainTabBarFlow(deepLinkOption: DeepLinkOption? = nil) {
        let router = MainRouter()
        let coordinator = MainTabBarCoordinator(router: router)
        self.addDependency(coordinator)
        coordinator.start()
    }

}
