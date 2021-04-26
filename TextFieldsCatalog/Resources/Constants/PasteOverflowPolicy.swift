// 
//  PasteOverflowPolicy.swift
//  TextFieldsCatalog
//
//  Created by Olesya Tranina on 26.04.2021.
//  Copyright © 2021 Александр Чаусов. All rights reserved.
//

/// Allows you to manage paste behaviors for text fields that use maxLength
public enum PasteOverflowPolicy {
    /// Pastes nothing if the text cannot fit completely
    case noChanges
    /// Pastes part of text that can fit
    case textThatFits
}
