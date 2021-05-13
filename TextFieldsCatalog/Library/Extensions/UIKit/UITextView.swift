//
//  UITextView.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 10/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit

extension UITextView {

    /// Returns `true` if input text is empty
    var isEmpty: Bool {
        return text.isEmpty
    }

    func moveCursorPosition(text: String, pasteLocation: Int, replacementString: String) {
        let maxOffset = (text as NSString).length
        let offset = min(maxOffset, pasteLocation + (replacementString as NSString).length)

        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }

            let contentOffset = self.contentOffset
            if let newPosition = self.position(from: self.beginningOfDocument, offset: offset) {
                self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
            }
            self.setContentOffset(contentOffset, animated: false)

            if let start = self.selectedTextRange?.start {
                let caret = self.caretRect(for: start)
                self.scrollRectToVisible(caret, animated: true)
            }
        }
    }

}
