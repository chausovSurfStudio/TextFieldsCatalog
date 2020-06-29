//
//  TextFieldsCatalogTests.swift
//  TextFieldsCatalogTests
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import TextFieldsCatalog

class TextFieldsCatalogTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        self.recordMode = true
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let field = UnderlinedTextField(frame: CGRect(x: 0, y: 0, width: 375, height: 77))
        FBSnapshotVerifyView(field)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
