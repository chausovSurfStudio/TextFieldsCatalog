//
//  SharedRegex.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 28/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

public enum SharedRegex {
    public static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    public static let everything = "(.*)"
    public static let password = "^((?=(.*\\d))(?=.*[A-Z])(?=.*[a-z]))(.{8,})"
}
