//
//  TextFieldValidator.swift
//  TextFieldsCatalogTests
//
//  Created by Александр Чаусов on 24/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import XCTest
@testable import TextFieldsCatalog

final class TextFieldValidatorTests: XCTestCase {

    // MARK: - Constants

    private enum Constants {
        static let minLength = 6
        static let maxLength = 10
        static let regex = SharedRegex.email

        static let emptyMessage = "empty"
        static let shortMessage = "short"
        static let largeMessage = "large"
        static let notValidMessage = "not valid"
    }

    // MARK: - Tests

    func testGlobalErrorMessage() {
        // given
        let globalMessage = "test global message"
        let validator = generateValidator(globalErrorMessage: globalMessage)
        let testData = ["", "a@a.a", "a@asdf.asdf", "asdasd"]

        for data in testData {
            // when
            let (isValid, text) = validator.validate(data)

            // then
            XCTAssertFalse(isValid)
            XCTAssertEqual(text, globalMessage)
        }
    }

    func testNotRequiredFlagPositive() {
        // given
        let validator = generateValidator(requiredField: false)

        // when
        let (isValid, text) = validator.validate("")

        // then
        XCTAssertTrue(isValid)
        XCTAssertNil(text)
    }

    func testNotRequiredFlagNegative() {
        // given
        let validator = generateValidator(requiredField: false)

        // when
        let (isValid, text) = validator.validate("a@a.a")

        // then
        XCTAssertFalse(isValid)
        XCTAssertEqual(text, Constants.shortMessage)
    }

    func testRegexPositive() {
        // given
        let validator = generateValidator()

        // when
        let (isValid, text) = validator.validate("m@mail.ru")

        // then
        XCTAssertTrue(isValid)
        XCTAssertNil(text)
    }

    func testRegexNegative() {
        // given
        let validator = generateValidator()

        // when
        let (isValid, text) = validator.validate("mail@mail")

        // then
        XCTAssertFalse(isValid)
        XCTAssertEqual(text, Constants.notValidMessage)
    }

    func testMaxLengthNegative() {
        // given
        let validator = generateValidator()

        // when
        let (isValid, text) = validator.validate("long_mail@mail.ru")

        // then
        XCTAssertFalse(isValid)
        XCTAssertEqual(text, Constants.largeMessage)
    }

    func testMinLengthNegative() {
        // given
        let validator = generateValidator()

        // when
        let (isValid, text) = validator.validate("asd")

        // then
        XCTAssertFalse(isValid)
        XCTAssertEqual(text, Constants.shortMessage)
    }

    func testEmptyInputText() {
        // given
        let validator = generateValidator()

        // when
        let (isValid, text) = validator.validate("")

        // then
        XCTAssertFalse(isValid)
        XCTAssertEqual(text, Constants.emptyMessage)
    }

    func testNilInputText() {
        // given
        let validator = generateValidator()

        // when
        let (isValid, text) = validator.validate(nil)

        // then
        XCTAssertFalse(isValid)
        XCTAssertEqual(text, Constants.emptyMessage)
    }

}

// MARK: - Private Methods

private extension TextFieldValidatorTests {

    func generateValidator(min: Int? = Constants.minLength,
                           max: Int? = Constants.maxLength,
                           regex: String? = Constants.regex,
                           globalErrorMessage: String? = nil,
                           requiredField: Bool = true) -> TextFieldValidator {
        let validator = TextFieldValidator(minLength: min,
                                           maxLength: max,
                                           regex: regex,
                                           globalErrorMessage: globalErrorMessage,
                                           requiredField: requiredField)
        validator.emptyErrorText = globalErrorMessage ?? Constants.emptyMessage
        validator.shortErrorText = globalErrorMessage ?? Constants.shortMessage
        validator.largeErrorText = globalErrorMessage ?? Constants.largeMessage
        validator.notValidErrorText = globalErrorMessage ?? Constants.notValidMessage
        return validator
    }

}
