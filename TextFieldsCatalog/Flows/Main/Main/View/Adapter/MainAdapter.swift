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
    var onItemSelect: CGFloatClosure?

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

// MARK: - Private Methods

private extension MainAdapter {

    func configureTableView() {
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func registerCells() {
    }

}

// MARK: - UITableViewDelegate

extension MainAdapter: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: "identifier")
        cell.textLabel?.text = "asd"
        return cell
    }

}
