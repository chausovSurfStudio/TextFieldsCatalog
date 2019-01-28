//
//  IconButton.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

final class IconButton: CommonButton {

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInitialState()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialState()
    }

    // MARK: - Internal Methods

    func setImageForAllState(_ image: UIImage?, normalColor: UIColor, pressedColor: UIColor) {
        guard let image = image else {
            return
        }
        setImage(image.mask(with: normalColor), for: .normal)
        setImage(image.mask(with: pressedColor), for: .selected)
        setImage(image.mask(with: pressedColor), for: .highlighted)
    }

}

private extension IconButton {

    func setupInitialState() {
        activeBackgroundColor = UIColor.clear
        highlightedBackgroundColor = UIColor.clear
    }

}
