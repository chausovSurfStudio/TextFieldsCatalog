//
//  StorkContainerViewController.swift
//  TextFieldsCatalogExample
//
//  Created by Александр Чаусов on 07/01/2020.
//  Copyright © 2020 Александр Чаусов. All rights reserved.
//

import UIKit

final class StorkContainerViewController: UIViewController {

    // MARK: - Private Properties

    private(set) var navController: UINavigationController?
    private var childController: UIViewController?

    // MARK: - Initialization

    convenience init(navController: UINavigationController) {
        self.init(nibName: StorkContainerViewController.nameOfClass,
                  bundle: Bundle(for: StorkContainerViewController.self))
        self.navController = navController
        self.childController = nil
    }

    convenience init(childController: UIViewController) {
        self.init(nibName: StorkContainerViewController.nameOfClass,
                  bundle: Bundle(for: StorkContainerViewController.self))
        self.navController = nil
        self.childController = childController
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK: - Configure

private extension StorkContainerViewController {

    func setupInitialState() {
        if let navController = navController {
            setupChildController(childController: navController)
        } else if let childController = childController {
            setupChildController(childController: childController)
        }
    }

    func setupChildController(childController: UIViewController) {
        childController.view.frame = CGRect(x: 0,
                                            y: 0,
                                            width: view.bounds.width,
                                            height: view.bounds.height)
        childController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addChild(childController)
        view.addSubview(childController.view)
        childController.didMove(toParent: self)
    }

}
