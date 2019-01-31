//
//  String.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 31/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

extension String {

    func height(forWidth width: CGFloat, font: UIFont, lineHeight: CGFloat) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight - font.lineHeight
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font,
                                                         NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let rect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return ceil(boundingBox.height)
    }

}
