//
//  UnderlinedViewTests.swift
//  TextFieldsCatalogExampleTests
//
//  Created by Александр Чаусов on 18.10.2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import TextFieldsCatalog

final class UnderlinedViewTests: FBSnapshotTestCase {

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
        let field = UnderlinedTextView(frame: Constants.frame)
        FBSnapshotVerifyView(field)
    }

    func testEmptyField() {
        let field = UnderlinedTextView(frame: Constants.frame)
        field.placeholder = "Placeholder"
        FBSnapshotVerifyView(field)
    }

    func testEmptyErrorField() {
        let field = UnderlinedTextView(frame: Constants.frame)
        field.placeholder = "Placeholder"
        field.setError(with: "Error message", animated: false)
        FBSnapshotVerifyView(field)
    }

    func testEmptyDisabledField() {
        let field = UnderlinedTextView(frame: Constants.frame)
        field.placeholder = "Placeholder"
        field.isEnabled = false
        FBSnapshotVerifyView(field)
    }

    func testFilledField() {
        let field = UnderlinedTextView(frame: Constants.frame)
        field.placeholder = "Placeholder"
        field.text = "Text"
        FBSnapshotVerifyView(field)
    }

    func testFilledErrorField() {
        let field = UnderlinedTextView(frame: Constants.frame)
        field.placeholder = "Placeholder"
        field.text = "Text"
        field.setError(with: "Error message", animated: false)
        FBSnapshotVerifyView(field)
    }

    func testFilledDisabledField() {
        let field = UnderlinedTextView(frame: Constants.frame)
        field.placeholder = "Placeholder"
        field.text = "Text"
        field.isEnabled = false
        FBSnapshotVerifyView(field)
    }

    func testMultilineErrorMessage() {
        let field = UnderlinedTextView(frame: Constants.frame)
        field.onHeightChanged = { height in
            field.frame.size.height = height
        }
        field.placeholder = "Placeholder"
        field.text = "Text"
        field.setError(with: "Error\nmessage", animated: false)
        FBSnapshotVerifyView(field)
    }

    func testMultilineText() {
        let field = UnderlinedTextView(frame: Constants.frame)
        field.onHeightChanged = { height in
            field.frame.size.height = height
        }
        field.placeholder = "Placeholder"
        field.text = "First row\nsecond row"
        FBSnapshotVerifyView(field)
    }

}
