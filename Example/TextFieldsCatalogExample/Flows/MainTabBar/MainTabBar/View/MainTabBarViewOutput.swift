//
//  MainTabBarViewOutput.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

protocol MainTabBarViewOutput {
    /// Notify presenter that user selects some tab
    ///
    /// - Parameter tab: which tab user did select
    /// - Parameter isInitial: flag, indicating that controller was created before
    /// - Parameter isStackEmpty: flag, indicating that controllers stack is empty and have only root controller
    func selectTab(with tab: MainTab, isInitial: Bool, isStackEmpty: Bool)
}
