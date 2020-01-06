//
//  CommonButton.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 28/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

class CommonButton: UIButton {

    // MARK: - Properties

    var activeBackgroundColor: UIColor = Color.Button.active {
        didSet {
            setBackgroundImage(UIImage(color: activeBackgroundColor), for: .normal)
        }
    }

    var highlightedBackgroundColor: UIColor = Color.Button.pressed {
        didSet {
            setBackgroundImage(UIImage(color: highlightedBackgroundColor), for: .highlighted)
        }
    }

    var disabledBackgroundColor: UIColor = Color.Button.disabled {
        didSet {
            setBackgroundImage(UIImage(color: disabledBackgroundColor), for: .disabled)
        }
    }

    var activeTitleColor: UIColor = Color.Text.black {
        didSet {
            setTitleColor(activeTitleColor, for: .normal)
        }
    }

    var highlightedTitleColor: UIColor = Color.Text.black {
        didSet {
            setTitleColor(highlightedTitleColor, for: .highlighted)
        }
    }

    var disabledTitleColor: UIColor = Color.Text.black {
        didSet {
            setTitleColor(disabledTitleColor, for: .disabled)
        }
    }

    var borderColor: UIColor = Color.Button.active {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    /// Increase touch area
    var addedTouchArea: CGFloat = 0.0

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - UIButton

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newBound = CGRect(
            x: bounds.origin.x - addedTouchArea,
            y: bounds.origin.y - addedTouchArea,
            width: bounds.width + 2 * addedTouchArea,
            height: bounds.height + 2 * addedTouchArea
        )
        return newBound.contains(point)
    }

    // MARK: - Public Methods

    func setTitleForAllState(_ title: String?) {
        setTitle(title, for: .normal)
        setTitle(title, for: .disabled)
        setTitle(title, for: .highlighted)
        setTitle(title, for: .selected)
    }

    func setImageForAllState(_ image: UIImage?) {
        setImage(image, for: .normal)
        setImage(image, for: .disabled)
        setImage(image, for: .highlighted)
        setImage(image, for: .selected)
    }

}
