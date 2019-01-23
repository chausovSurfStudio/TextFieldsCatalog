//
//  BorderedFieldPresetsAdapter.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

final class BorderedFieldPresetsAdapter: NSObject {

    // MARK: - Properties

    var onPresetSelect: BorderedFieldPresetClosure?

    // MARK: - Private Properties

    private var items: [BorderedFieldPreset]
    private let tableView: UITableView

    // MARK: - Initialization

    init(tableView: UITableView, items: [BorderedFieldPreset]) {
        self.tableView = tableView
        self.items = items
        super.init()
        configureTableView()
    }

    // MARK: - Internal Methods

}

// MARK: - Configure

private extension BorderedFieldPresetsAdapter {

    func configureTableView() {
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func registerCells() {
        tableView.registerNib(BorderedFieldPresetTableViewCell.self)
    }

}

// MARK: - UITableViewDelegate

extension BorderedFieldPresetsAdapter: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        onPresetSelect?(item)
    }

}

// MARK: - UITableViewDataSource

extension BorderedFieldPresetsAdapter: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(BorderedFieldPresetTableViewCell.self, indexPath: indexPath) else {
            return UITableViewCell()
        }
        let item = items[indexPath.row]
        cell.configure(with: item)
        return cell
    }

}
