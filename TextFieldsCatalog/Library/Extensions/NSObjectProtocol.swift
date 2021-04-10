//
//  NSObjectProtocol.swift
//  TextFieldsCatalog
//
//  Created by al.filimonov on 10.04.2021.
//

import Foundation

extension NSObjectProtocol {
    @discardableResult
    func apply(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}
