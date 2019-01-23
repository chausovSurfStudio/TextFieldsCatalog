//
//  MainAdapter.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

final class MainAdapter: NSObject {

    // MARK: - Properties

    var onScrolled: CGFloatClosure?
    var onFieldTypeSelect: TextFieldTypeClosure?

    // MARK: - Private Properties

    private var items: [MainModuleViewModel]
    private let tableView: UITableView

    // MARK: - Initialization

    init(tableView: UITableView, items: [MainModuleViewModel]) {
        self.tableView = tableView
        self.items = items
        super.init()
        configureTableView()
    }

    // MARK: - Internal Methods

}

// MARK: - Configure

private extension MainAdapter {

    func configureTableView() {
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func registerCells() {
        tableView.registerNib(MainFieldTableViewCell.self)
        tableView.registerNib(MainMessageTableViewCell.self)
    }

}

// MARK: - UITableViewDelegate

extension MainAdapter: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        switch item {
        case .field(let fieldType):
            onFieldTypeSelect?(fieldType)
        case .message(_):
            break
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScrolled?(scrollView.contentOffset.y)
    }

}

// MARK: - UITableViewDataSource

extension MainAdapter: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        switch item {
        case .field(let fieldType):
            return fieldCell(for: fieldType, indexPath: indexPath)
        case .message(let message):
            return messageCell(for: message, indexPath: indexPath)
        }
    }

}

// MARK: - Private Methods

private extension MainAdapter {

    func fieldCell(for fieldType: TextFieldType, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(MainFieldTableViewCell.self, indexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(with: fieldType)
        return cell
    }

    func messageCell(for message: String, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(MainMessageTableViewCell.self, indexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(with: message)
        return cell
    }

}
