//
//  MainTabBarPresenter.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

final class MainTabBarPresenter: MainTabBarModuleOutput {

    // MARK: - MainTabBarModuleOutput

    var onCatalogFlowSelect: TabSelectClosure?
    var onExampleFlowSelect: TabSelectClosure?
    var onInfoFlowSelect: TabSelectClosure?

    // MARK: - Properties

    weak var view: MainTabBarViewInput?

    // MARK: - Private Properties

    private var currentTab: MainTab? = .catalog

}

// MARK: - MainTabBarModuleInput

extension MainTabBarPresenter: MainTabBarModuleInput {

    func selectTab(_ tab: MainTab) {
        view?.selectTab(tab)
    }

}

// MARK: - MainTabBarViewOutput

extension MainTabBarPresenter: MainTabBarViewOutput {

    func selectTab(with tab: MainTab, isInitial: Bool, isStackEmpty: Bool) {
        let isChanging = currentTabIsChanged(newTab: tab)
        switch tab {
        case .catalog:
            onCatalogFlowSelect?(isInitial, isChanging, isStackEmpty)
        case .example:
            onExampleFlowSelect?(isInitial, isChanging, isStackEmpty)
        case .info:
            onInfoFlowSelect?(isInitial, isChanging, isStackEmpty)
        }
        currentTab = tab
    }

}

// MARK: - Private Methods

private extension MainTabBarPresenter {

    func currentTabIsChanged(newTab: MainTab) -> Bool {
        return currentTab != newTab
    }

}
