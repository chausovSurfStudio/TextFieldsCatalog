//
//  MainTabBarCoordinator.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

final class MainTabBarCoordinator: BaseCoordinator, MainTabBarCoordinatorOutput {

    // MARK: - MainTabBarCoordinatorOutput

    // MARK: - Private Properties

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    // MARK: - Coordinator

    override func start(with deepLinkOption: DeepLinkOption?) {
        showTabBar()
    }

}

// MARK: - Private Methods

private extension MainTabBarCoordinator {

    func showTabBar() {
        let (view, output) = MainTabBarModuleConfigurator().configure()

        output.onCatalogFlowSelect = { [weak self] isInitial, isChanging, isStackEmpty in
            self?.runCatalogFlow(isInitial: isInitial, isChanging: isChanging, isStackEmpty: isStackEmpty)
        }
        output.onExampleFlowSelect = { [weak self] isInitial, isChanging, isStackEmpty in
            self?.runExampleFlow(isInitial: isInitial, isChanging: isChanging, isStackEmpty: isStackEmpty)
        }
        output.onInfoFlowSelect = { [weak self] isInitial, isChanging, isStackEmpty in
            self?.runInfoFlow(isInitial: isInitial, isChanging: isChanging, isStackEmpty: isStackEmpty)
        }

        router.setRootModule(view)
        runCatalogFlow(isInitial: true, isChanging: false, isStackEmpty: true)
    }

    func runCatalogFlow(isInitial: Bool, isChanging: Bool, isStackEmpty: Bool) {
        guard isInitial else {
            return
        }
        let coordinator = MainCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }

    func runExampleFlow(isInitial: Bool, isChanging: Bool, isStackEmpty: Bool) {
        guard isInitial else {
            return
        }
        let coordinator = ExampleCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }

    func runInfoFlow(isInitial: Bool, isChanging: Bool, isStackEmpty: Bool) {
        guard isInitial else {
            return
        }
        let coordinator = InfoCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
    }

}
