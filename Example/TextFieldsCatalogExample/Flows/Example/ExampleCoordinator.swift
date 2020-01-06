//
//  ExampleCoordinator.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

final class ExampleCoordinator: BaseCoordinator, ExampleCoordinatorOutput {

    // MARK: - ExampleCoordinatorOutput

    // MARK: - Private Properties

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    // MARK: - Coordinator

    override func start(with deepLinkOption: DeepLinkOption?) {
        showExamples()
    }

}

// MARK: - Private Methods

private extension ExampleCoordinator {

    func showExamples() {
    }

}
