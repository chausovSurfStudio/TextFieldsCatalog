//
//  MainFieldTableViewCellTests.swift
//  TextFieldsCatalogExampleTests
//
//  Created by Александр Чаусов on 06/07/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import TextFieldsCatalogExample

final class MainFieldTableViewCellTests: FBSnapshotTestCase {

    // MARK: - Constants

    private enum Constants {
        static let width: CGFloat = 375
    }

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        self.recordMode = true
    }

    // MARK: - Tests

    func testCellLayout() {
        let container = TableViewCellSnapshotContainer<MainFieldTableViewCell>(width: Constants.width, configureCell: { cell in
            cell.configure(with: .underlined)
        })
        FBSnapshotVerifyView(container)
    }

}
