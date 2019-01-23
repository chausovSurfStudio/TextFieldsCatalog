//
//  UITableView.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import UIKit

extension UITableView {

    func registerNib(_ cellType: UITableViewCell.Type) {
        register(UINib(nibName: cellType.nameOfClass, bundle: nil), forCellReuseIdentifier: cellType.nameOfClass)
    }

    func dequeueReusableCell<Cell: UITableViewCell>(_ type: Cell.Type = Cell.self, indexPath: IndexPath) -> Cell? {
        return dequeueReusableCell(withIdentifier: Cell.identifier(), for: indexPath) as? Cell
    }

}
