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
            self?.showField(fieldType: fieldType)
        }
        router.setNavigationControllerRootModule(view, animated: false, hideBar: false)
    }

    func showField(fieldType: TextFieldType) {
        let (view, output, input) = FieldExampleModuleConfigurator().configure(with: fieldType)
        output.onChangePreset = { [weak self, weak input] fieldType in
            self?.showPresetsList(fieldType: fieldType, input: input)
        }
        router.push(view)
    }

    func showPresetsList(fieldType: TextFieldType, input: FieldExampleModuleInput?) {
        let (view, output) = FieldPresetsModuleConfigurator().configure(with: fieldType.presets)
        output.onClose = { [weak self] in
            self?.router.dismissModule()
        }
        output.onSelectPreset = { [weak self, weak input] preset in
            input?.applyPreset(preset)
            self?.router.dismissModule()
        }
        router.present(view)
    }

}
