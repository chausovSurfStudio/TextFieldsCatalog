//
//  UITextField.swift
//  TextFieldsCatalogTests
//
//  Created by Александр Чаусов on 01/03/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import XCTest
@testable import TextFieldsCatalog

final class UITextFieldTests: XCTestCase {

    // MARK: - Tests

    func testEmptyTextField() {
        // given
        let firstTextField = UITextField()
        let secondTextField = UITextField()
        secondTextField.text = ""

        // when
        let firstIsEmpty = firstTextField.isEmpty
        let secondIsEmpty = secondTextField.isEmpty

        // then
        XCTAssertTrue(firstIsEmpty)
        XCTAssertTrue(secondIsEmpty)
    }

    func testNotEmptyTextField() {
        // given
        let textField = UITextField()
        textField.text = "test"

        // when
        let fieldIsEmpty = textField.isEmpty

        // then
        XCTAssertFalse(fieldIsEmpty)
    }

}
