//
//  MainCoordinator.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

final class MainCoordinator: BaseCoordinator, MainCoordinatorOutput {

    // MARK: - MainCoordinatorOutput

    var finishFlow: EmptyClosure?

    // MARK: - Private Properties

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    // MARK: - Coordinator

    override func start(with deepLinkOption: DeepLinkOption?) {
        showMain()
    }

}

// MARK: - Private Methods

private extension MainCoordinator {

    func showMain() {
        let (view, output) = MainModuleConfigurator().configure()
        output.onFieldOpen = { [weak self] fieldType in
            self?.runFieldFlow(with: fieldType)
        }
        router.setRootModule(view)
    }

    func runFieldFlow(with fieldType: TextFieldType) {
        let coordinator = FieldCoordinator(router: router, fieldType: fieldType)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }

    func runBorderedFieldFlow() {
        let coordinator = BorderedFieldCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }

}
