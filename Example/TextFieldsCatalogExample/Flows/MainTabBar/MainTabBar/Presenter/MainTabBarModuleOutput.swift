//
//  MainTabBarModuleOutput.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

public typealias TabSelectClosure = (_ isInitial: Bool, _ isChanging: Bool, _ isStackEmpty: Bool) -> Void

protocol MainTabBarModuleOutput: class {
    var onCatalogFlowSelect: TabSelectClosure? { get set }
    var onExampleFlowSelect: TabSelectClosure? { get set }
    var onInfoFlowSelect: TabSelectClosure? { get set }
}
