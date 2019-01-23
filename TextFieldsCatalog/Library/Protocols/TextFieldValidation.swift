//
//  TextFieldValidation.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

protocol TextFieldValidation: class {
    func validate(_ text: String?) -> (isValid: Bool, errorMessage: String?)
}
