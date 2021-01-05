//
//  HintMessageState.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 05.01.2021.
//  Copyright © 2021 Александр Чаусов. All rights reserved.
//

/// Option set for managing possible visible states for fields hint message.
///
/// You can provide needed set to hint service init method or
/// change this set for specific field with appropriate method.
/// Hint or error messages will be shown only for specified states.
public struct HintVisibleStates: OptionSet {

    // MARK: - Public Properties

    public let rawValue: Int

    public static let error = HintVisibleStates(rawValue: 1 << 0)
    public static let disabled = HintVisibleStates(rawValue: 1 << 1)
    public static let normal = HintVisibleStates(rawValue: 1 << 2)
    public static let active = HintVisibleStates(rawValue: 1 << 3)

    public static let all: HintVisibleStates = [.error, .disabled, .normal, .active]

    // MARK: - Initialization

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

}
