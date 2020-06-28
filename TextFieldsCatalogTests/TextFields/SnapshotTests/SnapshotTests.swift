//
//  SnapshotTests.swift
//  TextFieldsCatalogTests
//
//  Created by Александр Чаусов on 28/06/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit
import FBSnapshotTestCase
@testable import TextFieldsCatalog

final class SnapshotTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        self.recordMode = true
    }

    func testMothefucker() {
        let field = UnderlinedTextField(frame: CGRect(x: 0, y: 0, width: 375, height: 77))
        FBSnapshotVerifyView(field)
    }

    func testOne() {
        let field = UnderlinedTextField(frame: CGRect(x: 0, y: 0, width: 375, height: 77))
        FBSnapshotVerifyView(field)
    }

    func testTwo() {
        let field = UnderlinedTextField(frame: CGRect(x: 0, y: 0, width: 375, height: 77))
        FBSnapshotVerifyView(field)
    }

}
