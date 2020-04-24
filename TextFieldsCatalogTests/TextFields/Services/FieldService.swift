//
//  FieldService.swift
//  TextFieldsCatalogTests
//
//  Created by Александр Чаусов on 24/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import XCTest
@testable import TextFieldsCatalog

final class FieldServiceTests: XCTestCase {

    // MARK: - Constants

    private enum Constants {
        static let font = UIFont.systemFont(ofSize: 12)
        static let defaultPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let increasedPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
        static let tintColor = UIColor.systemPink
        static let colors = ColorConfiguration(error: UIColor.red,
                                               normal: UIColor.purple,
                                               active: UIColor.green,
                                               disabled: UIColor.gray)
        static let backgroundColor = UIColor.brown
    }

    // MARK: - Tests

    func testBackgroundConfig() {
        // given
        let superview = UIView()
        let field = InnerTextField()
        let service = generateService(for: field)
        superview.addSubview(field)

        // when
        service.configureBackground()

        // then
        XCTAssertEqual(field.superview?.backgroundColor, Constants.backgroundColor)
        XCTAssertEqual(field.backgroundColor, UIColor.clear)
    }

    func testTextFieldConfig() {
        // given
        let field = InnerTextField()
        let service = generateService(for: field)

        // when
        service.configure(textField: field)

        // then
        XCTAssertEqual(field.font, Constants.font)
        XCTAssertEqual(field.textPadding, Constants.defaultPadding)
        XCTAssertEqual(field.tintColor, Constants.tintColor)
        XCTAssertEqual(field.textColor, Constants.colors.normal)
    }

    func testTextViewConfig() {
        // given
        let field = UITextView()
        let service = generateService(for: field)

        // when
        service.configure(textView: field)

        // then
        XCTAssertEqual(field.font, Constants.font)
        XCTAssertEqual(field.tintColor, Constants.tintColor)
        XCTAssertEqual(field.textColor, Constants.colors.normal)
    }

    func testUpdateMethod() {
        // given
        typealias TestData = (state: FieldContainerState, color: UIColor)
        let testData: [TestData] = [
            (.normal, Constants.colors.normal),
            (.active, Constants.colors.active),
            (.disabled, Constants.colors.disabled),
            (.error, Constants.colors.error)
        ]
        let field = InnerTextField()
        let service = generateService(for: field)
        service.configure(textField: field)

        for data in testData {
            // when
            service.updateContent(containerState: data.state)

            // then
            XCTAssertEqual(field.textColor, data.color)
        }
    }

}

// MARK: - Private Methods

private extension FieldServiceTests {

    func generateService(for field: InputField) -> FieldService {
        let configuration = TextFieldConfiguration(font: Constants.font,
                                                   defaultPadding: Constants.defaultPadding,
                                                   increasedPadding: Constants.increasedPadding,
                                                   tintColor: Constants.tintColor,
                                                   colors: Constants.colors)
        let backgroundConfig = BackgroundConfiguration(color: Constants.backgroundColor)
        return FieldService(field: field,
                            configuration: configuration,
                            backgroundConfiguration: backgroundConfig)
    }

}
