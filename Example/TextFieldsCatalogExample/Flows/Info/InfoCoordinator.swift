//
//  InfoCoordinator.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

final class InfoCoordinator: BaseCoordinator, InfoCoordinatorOutput {

    // MARK: - InfoCoordinatorOutput

    // MARK: - Private Properties

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    // MARK: - Coordinator

    override func start(with deepLinkOption: DeepLinkOption?) {
        showInfo()
    }

}

// MARK: - Private Methods

private extension InfoCoordinator {

    func showInfo() {
        let (view, _) = InfoModuleConfigurator().configure()
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

}
