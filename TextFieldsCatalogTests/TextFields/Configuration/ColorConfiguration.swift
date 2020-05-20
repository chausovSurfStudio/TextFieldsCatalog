//
//  ColorConfiguration.swift
//  TextFieldsCatalogTests
//
//  Created by Александр Чаусов on 24/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import XCTest
@testable import TextFieldsCatalog

final class ColorConfigurationTests: XCTestCase {

    // MARK: - Constants

    private enum Constants {
        static let errorColor = UIColor.red
        static let normalColor = UIColor.black
        static let activeColor = UIColor.green
        static let disabledColor = UIColor.gray
    }

    // MARK: - Tests

    func testSuitableColorForFieldState() {
        // given
        typealias TestData = (color: UIColor, state: FieldState, isError: Bool)
        let configuration = ColorConfiguration(error: Constants.errorColor,
                                               normal: Constants.normalColor,
                                               active: Constants.activeColor,
                                               disabled: Constants.disabledColor)
        let testData: [TestData] = [
            (Constants.errorColor, .active, true),
            (Constants.errorColor, .normal, true),
            (Constants.errorColor, .disabled, true),
            (Constants.activeColor, .active, false),
            (Constants.normalColor, .normal, false),
            (Constants.disabledColor, .disabled, false)
        ]

        for data in testData {
            // when
            let color = configuration.suitableColor(fieldState: data.state, isActiveError: data.isError)

            // then
            XCTAssertEqual(data.color, color)
        }
    }

    func testSuitableColorForContainerState() {
        // given
        typealias TestData = (color: UIColor, state: FieldContainerState)
        let configuration = ColorConfiguration(error: Constants.errorColor,
                                               normal: Constants.normalColor,
                                               active: Constants.activeColor,
                                               disabled: Constants.disabledColor)
        let testData: [TestData] = [
            (Constants.errorColor, .error),
            (Constants.activeColor, .active),
            (Constants.normalColor, .normal),
            (Constants.disabledColor, .disabled)
        ]

        for data in testData {
            // when
            let color = configuration.suitableColor(state: data.state)

            // then
            XCTAssertEqual(data.color, color)
        }
    }

}
