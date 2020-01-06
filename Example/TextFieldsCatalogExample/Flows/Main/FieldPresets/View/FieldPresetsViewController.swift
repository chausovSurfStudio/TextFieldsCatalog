//
//  FieldPresetsViewController.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 24/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import UIKit

final class FieldPresetsViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var container: UIView!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    var output: FieldPresetsViewOutput?

    // MARK: - Private Properties

    private var adapter: FieldPresetsAdapter?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

}

// MARK: - FieldPresetsViewInput

extension FieldPresetsViewController: FieldPresetsViewInput {

    func setupInitialState(with presets: [AppliedPreset]) {
        configureAppearance()
        configureAdapter(with: presets)
    }

}

// MARK: - Configure

private extension FieldPresetsViewController {

    func configureAppearance() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        tableView.backgroundColor = Color.Main.container
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        configureContainer()
        configureGestures()
    }

    func configureContainer() {
        container.layer.cornerRadius = 12
        container.layer.masksToBounds = true
    }

    func configureGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }

    func configureAdapter(with presets: [AppliedPreset]) {
        adapter = FieldPresetsAdapter(tableView: tableView, items: presets)
        adapter?.onPresetSelect = { [weak self] preset in
            self?.output?.selectPreset(preset)
        }
    }

}

// MARK: - Actions

private extension FieldPresetsViewController {

    @objc
    func handleBackgroundTap() {
        output?.close()
    }

}

// MARK: - UIGestureRecognizerDelegate

extension FieldPresetsViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == view
    }

}
