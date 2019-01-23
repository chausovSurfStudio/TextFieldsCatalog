//
//  MainMessageTableViewCell.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import SurfUtils

final class MainMessageTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var messageLabel: UILabel!

    // MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    // MARK: - Internal Methods

    func configure(with message: String) {
        messageLabel.attributedText = message.with(attributes: [.lineHeight(18, font: UIFont.systemFont(ofSize: 14, weight: .regular)),
                                                                .foregroundColor(Color.Text.white)])
    }

}

// MARK: - Configure

private extension MainMessageTableViewCell {

    func setupInitialState() {
        selectionStyle = .none
        contentView.backgroundColor = Color.Cell.background
        messageLabel.numberOfLines = 0
    }

}
