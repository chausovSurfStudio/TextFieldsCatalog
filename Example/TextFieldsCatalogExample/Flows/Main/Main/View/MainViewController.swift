//
//  MainViewController.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController, CustomNavigationTitlePresentable {

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    var output: MainViewOutput?

    // MARK: - Private Properties

    private var adapter: MainAdapter?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewLoaded()
    }

}

// MARK: - MainViewInput

extension MainViewController: MainViewInput {

    func setupInitialState(with models: [MainModuleViewModel], title: String) {
        configureAppearance(with: title)
        configureAdapter(with: models)
    }

}

// MARK: - Configure

private extension MainViewController {

    func configureAppearance(with title: String) {
        view.backgroundColor = Color.Main.background
        configureTableView(with: title)
        configureNavigationBar(with: title)
    }

    func configureTableView(with title: String) {
        tableView.backgroundColor = Color.Main.background
        tableView.separatorStyle = .none
        tableView.tableHeaderView = CommonTableHeader.header(for: title)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }

    func configureNavigationBar(with title: String) {
        configureNavigationTitle(with: title)
    }

    func configureAdapter(with models: [MainModuleViewModel]) {
        adapter = MainAdapter(tableView: tableView, items: models)
        adapter?.onScrolled = { [weak self] offset in
            self?.updateNavigationTitle(for: offset)
        }
        adapter?.onFieldTypeSelect = { [weak self] type in
            self?.output?.openField(with: type)
        }
    }

}
