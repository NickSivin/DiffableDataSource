//
//  TableCell.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol TableCellViewModel: ConfigurableViewModel {
    var selectionStyle: UITableViewCell.SelectionStyle { get }
    var accessoryType: UITableViewCell.AccessoryType { get }
    func select(deselectionClosure: (() -> Void)?)
}

extension TableCellViewModel {
    func select(deselectionClosure: (() -> Void)?) {
        select(deselectionClosure: deselectionClosure)
    }
    
    var selectionStyle: UITableViewCell.SelectionStyle {
        return .none
    }
    
    var accessoryType: UITableViewCell.AccessoryType {
        return .none
    }
}

protocol TableCellContainerViewModel: TableCellViewModel {
    var contentViewModel: TableCellViewModel { get }
}

extension TableCellContainerViewModel {
    func select(deselectionClosure: (() -> Void)?) {
        contentViewModel.select(deselectionClosure: deselectionClosure)
    }
}

protocol TableCell {
    func configure(with viewModel: TableCellViewModel)
}

