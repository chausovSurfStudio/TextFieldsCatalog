//
//  AssetManager.swift
//  TextFieldsCatalogTests
//
//  Created by Александр Чаусов on 24/04/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import XCTest
@testable import TextFieldsCatalog

final class AssetManagerTests: XCTestCase {

    // MARK: - Tests

    func testImageGeneration() {
        // given
        let imageName = "close"

        // when
        let image = AssetManager().getImage(imageName)

        // then
        XCTAssertNotNil(image)
    }

}
