//
//  TextFieldType.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

enum TextFieldType {
    case bordered

    var title: String {
        switch self {
        case .bordered:
            return "Поле ввода с обводкой"
        }
    }

    var description: String {
        switch self {
        case .bordered:
            return "Границы поля ввода скруглены и подсвечены, имеется плейсхолдер над полем ввода, информационное-сообщение или сообщение об ошибке внизу, в одну строку. Есть возможность кастомизации с помощью своей кнопки. Кастомизируется под ввод пароля. Поддержка валидаторов и форматтеров."
        }
    }
}
