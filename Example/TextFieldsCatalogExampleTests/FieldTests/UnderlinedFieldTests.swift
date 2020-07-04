//
//  UnderlinedFieldTests.swift
//  TextFieldsCatalogExampleTests
//
//  Created by Александр Чаусов on 04/07/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import TextFieldsCatalog

final class UnderlinedFieldTests: FBSnapshotTestCase {

    // MARK: - Constants

    private enum Constants {
        static let frame = CGRect(x: 0, y: 0, width: 375, height: 77)
    }

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        self.recordMode = false
    }

    // MARK: - Tests

    func testDefaultField() {
        let field = UnderlinedTextField(frame: Constants.frame)
        FBSnapshotVerifyView(field)
    }

    func testEmptyField() {
        let field = UnderlinedTextField(frame: Constants.frame)
        field.placeholder = "Placeholder"
        FBSnapshotVerifyView(field)
    }

    func testEmptyErrorField() {
        let field = UnderlinedTextField(frame: Constants.frame)
        field.placeholder = "Placeholder"
        field.setError(with: "Error message", animated: false)
        FBSnapshotVerifyView(field)
    }

    func testEmptyDisabledField() {
        let field = UnderlinedTextField(frame: Constants.frame)
        field.placeholder = "Placeholder"
        field.isEnabled = false
        FBSnapshotVerifyView(field)
    }

    func testFilledField() {
        let field = UnderlinedTextField(frame: Constants.frame)
        field.placeholder = "Placeholder"
        field.text = "Text"
        FBSnapshotVerifyView(field)
    }

    func testFilledErrorField() {
        let field = UnderlinedTextField(frame: Constants.frame)
        field.placeholder = "Placeholder"
        field.text = "Text"
        field.setError(with: "Error message", animated: false)
        FBSnapshotVerifyView(field)
    }

    func testFilledDisabledField() {
        let field = UnderlinedTextField(frame: Constants.frame)
        field.placeholder = "Placeholder"
        field.text = "Text"
        field.isEnabled = false
        FBSnapshotVerifyView(field)
    }

    func testPasswordEmptyField() {
        let field = UnderlinedTextField(frame: Constants.frame)
        field.placeholder = "Password field"
        field.mode = .password(.alwaysVisible)
        FBSnapshotVerifyView(field)
    }

    func testPasswordSecureField() {
        let field = UnderlinedTextField(frame: Constants.frame)
        field.placeholder = "Password field"
        field.mode = .password(.alwaysVisible)
        field.text = "password1"
        FBSnapshotVerifyView(field)
    }

    func testPasswordVisibleField() {
        let field = UnderlinedTextField(frame: Constants.frame)
        field.placeholder = "Password field"
        field.mode = .password(.alwaysVisible)
        field.text = "password1"
        field.field.isSecureTextEntry = false
        FBSnapshotVerifyView(field)
    }

    func testMultilineErrorMessage() {
        let field = UnderlinedTextField(frame: Constants.frame)
        field.onHeightChanged = { height in
            field.frame.size.height = height
        }
        field.placeholder = "Placeholder"
        field.text = "Text"
        field.setError(with: "Error\nmessage", animated: false)
        FBSnapshotVerifyView(field)
    }

}
