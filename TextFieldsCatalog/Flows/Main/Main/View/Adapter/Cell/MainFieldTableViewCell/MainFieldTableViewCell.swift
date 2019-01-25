//
//  MainFieldTableViewCell.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit
import SurfUtils

final class MainFieldTableViewCell: UITableViewCell {

    // MARK: - Constants

    private enum Constants {
        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var container: UIView!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.container.backgroundColor = selected ? Color.Cell.pressed : Color.Cell.container
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.container.backgroundColor = highlighted ? Color.Cell.pressed : Color.Cell.container
        }
    }

    // MARK: - Internal Methods

    func configure(with fieldType: TextFieldType) {
        headerLabel.attributedText = fieldType.title.with(attributes: [.lineHeight(22, font: UIFont.systemFont(ofSize: 18, weight: .semibold)),
                                                                       .foregroundColor(Color.Text.white)])
        descriptionLabel.attributedText = fieldType.description.with(attributes: [.lineHeight(20, font: UIFont.systemFont(ofSize: 14, weight: .regular)),
                                                                                  .foregroundColor(Color.Text.white)])
    }

}

// MARK: - Configure

private extension MainFieldTableViewCell {

    func setupInitialState() {
        contentView.backgroundColor = Color.Cell.background
        container.backgroundColor = Color.Cell.container
        container.layer.cornerRadius = 12
        container.layer.masksToBounds = true
        headerLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
    }

}
