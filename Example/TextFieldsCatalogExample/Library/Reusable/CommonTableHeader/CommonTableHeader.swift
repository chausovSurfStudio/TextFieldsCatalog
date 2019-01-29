//
//  CommonTableHeader.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import SurfUtils

final class CommonTableHeader: DesignableView {

    // MARK: - Constants

    private enum Constants {
        static let freeVerticalTopSpace: CGFloat = 10
        static let freeHorizontalSpace: CGFloat = 32
        static let headerFont = UIFont.systemFont(ofSize: 34, weight: .bold)
        static let headerLineHeight: CGFloat = 41
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var headerLabel: UILabel!

    // MARK: - UIView

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

    /// Returns instance of CommonTableHeader with correct height
    static func header(for title: String, bottomSpace: CGFloat = 20) -> CommonTableHeader {
        let screenWidth = UIScreen.main.bounds.width
        let headerHeight = title.height(forWidth: (screenWidth - Constants.freeHorizontalSpace),
                                        attributes: attributesForHeader())
        let height = [Constants.freeVerticalTopSpace,
                      headerHeight,
                      bottomSpace].reduce(0, +)
        let header = CommonTableHeader(frame: CGRect(x: 0, y: 0, width: screenWidth, height: height))
        header.headerLabel.attributedText = title.with(attributes: [.lineHeight(Constants.headerLineHeight, font: Constants.headerFont),
                                                                    .foregroundColor(Color.Text.white)])
        return header
    }

}

// MARK: - Private Configuration

private extension CommonTableHeader {

    func setupInitialState() {
        headerLabel.numberOfLines = 0
        view.backgroundColor = Color.Main.background
    }

    static func attributesForHeader() -> [NSAttributedString.Key: Any] {
        let font = Constants.headerFont
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = Constants.headerLineHeight - font.lineHeight

        return [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
    }

}
