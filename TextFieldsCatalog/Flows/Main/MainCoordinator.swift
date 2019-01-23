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
        let (view, _) = MainModuleConfigurator().configure()
        router.setRootModule(view)
    }

}
