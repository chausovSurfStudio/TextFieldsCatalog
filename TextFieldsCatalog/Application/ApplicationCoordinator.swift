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
        runMainFlow()
    }

}

// MARK: - Private Methods

private extension ApplicationCoordinator {

    func runMainFlow(deepLinkOption: DeepLinkOption? = nil) {
        let router = MainRouter()
        let coordinator = MainCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.start(with: deepLinkOption)
            self?.removeDependency(coordinator)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }

}
