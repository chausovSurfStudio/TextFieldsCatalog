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
        output.onInfoOpen = { [weak self] in
            self?.showInfo()
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func showInfo() {
        let (view, _) = InfoModuleConfigurator().configure()
        router.push(view)
    }

    func runFieldFlow(with fieldType: TextFieldType) {
        let coordinator = FieldCoordinator(router: router, fieldType: fieldType)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }

}
