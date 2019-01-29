//
//  FieldCoordinator.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 24/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

final class FieldCoordinator: BaseCoordinator, FieldCoordinatorOutput {

    // MARK: - FieldCoordinatorOutput

    var finishFlow: EmptyClosure?

    // MARK: - Private Properties

    private let router: Router
    private let fieldType: TextFieldType

    // MARK: - Initialization

    init(router: Router, fieldType: TextFieldType) {
        self.router = router
        self.fieldType = fieldType
    }

    // MARK: - Coordinator

    override func start(with deepLinkOption: DeepLinkOption?) {
        showExample()
    }

}

// MARK: - Private Methods

private extension FieldCoordinator {

    func showExample() {
        let (view, output, input) = FieldExampleModuleConfigurator().configure(with: fieldType)
        output.onClose = { [weak self] in
            self?.router.dismissModule()
            self?.finishFlow?()
        }
        output.onChangePreset = { [weak self, weak input] in
            self?.showPresetsList(input: input)
        }
        router.present(view)
    }

    func showPresetsList(input: FieldExampleModuleInput?) {
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
