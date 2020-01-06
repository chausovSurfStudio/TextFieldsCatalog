//
//  MainTabBarModuleInput.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

protocol MainTabBarModuleInput: class {
    /// Method allows you to change selected tab
    func selectTab(_ tab: MainTab)
}
