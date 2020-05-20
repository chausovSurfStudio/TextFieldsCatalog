//
//  MaskTextFieldFormatter.swift
//  TextFieldsCatalogTests
//
//  Created by Александр Чаусов on 24/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import XCTest
@testable import TextFieldsCatalog

final class MaskTextFieldFormatterTests: XCTestCase {

    // MARK: - Tests

    func testFormatting() {
        // given
        typealias TestData = (mask: String, value: String?, result: String?)
        let testData: [TestData] = [
            (FormatterMasks.phone, "79005553333", "+7 (900) 555-33-33"),
            (FormatterMasks.cardExpirationDate, "asd3265", "32/65"),
            (FormatterMasks.cvc, "!654", "654"),
            (FormatterMasks.cardNumber, "12345678901234567", "1234 5678 9012 3456 7"),
            (FormatterMasks.cardNumber, nil, nil),
            (FormatterMasks.cardNumber, "", "")
        ]

        for data in testData {
            // when
            let result = MaskTextFieldFormatter(mask: data.mask).format(string: data.value)

            // then
            XCTAssertEqual(result, data.result)
        }
    }

}
