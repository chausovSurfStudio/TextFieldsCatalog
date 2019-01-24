//
//  FieldCoordinatorOutput.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 24/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

protocol FieldCoordinatorOutput: class {
    var finishFlow: EmptyClosure? { get set }
}
