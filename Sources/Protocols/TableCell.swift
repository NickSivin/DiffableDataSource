//
//  TableCell.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol TableCellViewModel: DiffableDataItem {
    var reuseIdentifier: String { get }
    var selectionStyle: UITableViewCell.SelectionStyle { get }
    var accessoryType: UITableViewCell.AccessoryType { get }
    
    func selectTableCell()
    func select(deselectionClosure: (() -> Void)?)
}

extension TableCellViewModel {
    func selectTableCell() {
        // do nothing by default
    }
    
    func select(deselectionClosure: (() -> Void)?) {
        selectTableCell()
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

