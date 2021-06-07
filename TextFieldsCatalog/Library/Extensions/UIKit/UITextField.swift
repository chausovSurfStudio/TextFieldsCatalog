//
//  UITextField.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 10/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit

extension UITextField {

    /// Returns `true` if input text is empty
    var isEmpty: Bool {
        return text?.isEmpty ?? true
    }

    func moveCursorPosition(text: String, pasteLocation: Int, replacementString: String) {
        let maxOffset = (text as NSString).length
        let offset = min(maxOffset, pasteLocation + (replacementString as NSString).length)

        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            if let newPosition = self.position(from: self.beginningOfDocument, offset: offset) {
                self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
            }
        }
    }

    func fixCursorPosition(pasteLocation: Int) {
        moveCursorPosition(text: self.text ?? "", pasteLocation: pasteLocation, replacementString: "")
    }

}
