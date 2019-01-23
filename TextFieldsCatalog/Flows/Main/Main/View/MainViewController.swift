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
        tableView.backgroundColor = Color.Main.background
        tableView.separatorStyle = .none
        configureNavigationTitle(with: title)
        tableView.tableHeaderView = CommonTableHeader.header(for: title)
    }

    func configureAdapter(with models: [MainModuleViewModel]) {
        adapter = MainAdapter(tableView: tableView, items: models)
        adapter?.onScrolled = { [weak self] offset in
            self?.updateNavigationTitle(for: offset)
        }
    }

}
