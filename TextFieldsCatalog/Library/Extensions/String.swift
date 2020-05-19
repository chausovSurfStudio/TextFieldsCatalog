//
//  String.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 31/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

extension String {

    func height(forWidth width: CGFloat, font: UIFont, lineHeight: CGFloat?) -> CGFloat {
        var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        if let lineHeight = lineHeight {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineHeight - font.lineHeight
            attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        }
        let rect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return ceil(boundingBox.height)
    }

    func width(forHeight height: CGFloat, font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let rect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: rect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: attributes,
                                            context: nil)
        return ceil(boundingBox.width)
    }

    func with(lineHeight: CGFloat, font: UIFont, color: UIColor) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight - font.lineHeight
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font,
                                                         NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                                         NSAttributedString.Key.foregroundColor: color]
        return NSAttributedString(string: self, attributes: attributes)
    }

}
