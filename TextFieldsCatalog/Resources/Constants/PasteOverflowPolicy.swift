// 
//  PasteOverflowPolicy.swift
//  TextFieldsCatalog
//

/// Allows you to manage paste behaviors for text fields that use maxLength
public enum PasteOverflowPolicy {
    /// Pastes nothing if the text cannot fit completely
    case noChanges
    /// Pastes part of text that can fit 
    case textThatFits
}
