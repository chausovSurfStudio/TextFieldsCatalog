//
//  FieldPresetsAdapter.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 24/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

final class FieldPresetsAdapter: NSObject {

    // MARK: - Properties

    var onPresetSelect: FieldPresetClosure?

    // MARK: - Private Properties

    private var items: [AppliedPreset]
    private let tableView: UITableView

    // MARK: - Initialization

    init(tableView: UITableView, items: [AppliedPreset]) {
        self.tableView = tableView
        self.items = items
        super.init()
        configureTableView()
    }

}

// MARK: - Configure

private extension FieldPresetsAdapter {

    func configureTableView() {
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func registerCells() {
        tableView.registerNib(FieldPresetTableViewCell.self)
    }

}

// MARK: - UITableViewDelegate

extension FieldPresetsAdapter: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        onPresetSelect?(item)
    }

}

// MARK: - UITableViewDataSource

extension FieldPresetsAdapter: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(FieldPresetTableViewCell.self, indexPath: indexPath) else {
            return UITableViewCell()
        }
        let item = items[indexPath.row]
        cell.configure(with: item)
        return cell
    }

}
