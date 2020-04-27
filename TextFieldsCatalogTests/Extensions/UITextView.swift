//
//  UITextView.swift
//  TextFieldsCatalogTests
//
//  Created by Александр Чаусов on 01/03/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import XCTest
@testable import TextFieldsCatalog

final class UITextViewTests: XCTestCase {

    // MARK: - Tests

    func testEmptyTextView() {
        // given
        let textView = UITextView()

        // when
        let viewIsEmpty = textView.isEmpty

        // then
        XCTAssertTrue(viewIsEmpty)
    }

    func testNotEmptyTextView() {
        // given
        let textView = UITextField()
        textView.text = "test"

        // when
        let viewIsEmpty = textView.isEmpty

        // then
        XCTAssertFalse(viewIsEmpty)
    }

}
