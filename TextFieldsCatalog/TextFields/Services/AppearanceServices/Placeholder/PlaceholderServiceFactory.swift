//
//  PlaceholderServiceFactory.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 27/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

final class PlaceholderServiceFactory {

    func produce(type: PlaceholderType,
                 superview: InnerDesignableView,
                 field: InputField?) -> AbstractPlaceholderService {
        switch type {
        case .floating(let config):
            return FloatingPlaceholderService(superview: superview, field: field, configuration: config)
        case .static(let config):
            return StaticPlaceholderService(superview: superview, field: field, configuration: config)
        }
    }

}
