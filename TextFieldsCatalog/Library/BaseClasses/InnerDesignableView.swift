//
//  InnerDesignableView.swift
//  TextFieldsCatalog
//
//  Created by Alexandr Olferuk on 21/07/16.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

/// Inherit custom subview from this class instead of UIView,
///     mark it as @IBDesignable,
///     set the file's owner and do not set the View's class,
///     =>
///     It renders in the IB!
open class InnerDesignableView: UIView {

    var view: UIView {
        return subviews.first ?? UIView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _ = setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = setup()
    }

    func setup() -> UIView? {
        let view = Bundle(for: type(of: self)).loadNibNamed(self.nameOfClass, owner: self, options: nil)?.first as? UIView
        if let v = view {
            addSubview(v)
            v.frame = self.bounds
        }
        return view
    }

}
