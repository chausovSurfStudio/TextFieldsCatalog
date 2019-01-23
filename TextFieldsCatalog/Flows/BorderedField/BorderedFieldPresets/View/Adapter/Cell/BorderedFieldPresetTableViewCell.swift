//
//  BorderedFieldPresetTableViewCell.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

final class BorderedFieldPresetTableViewCell: UITableViewCell {

    // MARK: - Constants

    private enum Constants {
        static let animationDuration: TimeInterval = 0.3
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.contentView.backgroundColor = selected ? Color.Cell.pressed : Color.Cell.container
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.contentView.backgroundColor = highlighted ? Color.Cell.pressed : Color.Cell.container
        }
    }

    // MARK: - Internal Methods

    func configure(with preset: BorderedFieldPreset) {
        nameLabel.text = preset.name
    }

}

// MARK: - Configure

private extension BorderedFieldPresetTableViewCell {

    func setupInitialState() {
        contentView.backgroundColor = Color.Cell.container
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = Color.Text.white
    }

}
