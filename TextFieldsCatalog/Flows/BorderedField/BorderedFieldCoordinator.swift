//
//  BorderedFieldCoordinator.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

final class BorderedFieldCoordinator: BaseCoordinator, BorderedFieldCoordinatorOutput {

    // MARK: - BorderedFieldCoordinatorOutput

    var finishFlow: EmptyClosure?

    // MARK: - Private Properties

    private let router: Router

    // MARK: - Initialization

    init(router: Router) {
        self.router = router
    }

    // MARK: - Coordinator

    override func start(with deepLinkOption: DeepLinkOption?) {
        showExample()
    }

}

// MARK: - Private Methods

private extension BorderedFieldCoordinator {

    func showExample() {
//        let (view, output, input) = BorderedFieldExampleModuleConfigurator().configure()
//        output.onClose = { [weak self] in
//            self?.router.dismissModule()
//            self?.finishFlow?()
//        }
//        output.onChangePreset = { [weak self, weak input] in
//            self?.showPresetsList(input: input)
//        }
//        router.present(view)
    }

//    func showPresetsList(input: BorderedFieldExampleModuleInput?) {
//        let (view, output) = BorderedFieldPresetsModuleConfigurator().configure()
//        output.onClose = { [weak self] in
//            self?.router.dismissModule()
//        }
//        output.onSelectPreset = { [weak self, weak input] preset in
//            input?.applyPreset(preset)
//            self?.router.dismissModule()
//        }
//        router.present(view)
//    }

}
