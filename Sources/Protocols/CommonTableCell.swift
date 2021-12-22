//
//  CommonTableCell.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol CommonTableCellViewModel: CommonDiffableDataItem {
    var reuseIdentifier: String { get }
    var selectionStyle: UITableViewCell.SelectionStyle { get }
    var accessoryType: UITableViewCell.AccessoryType { get }
    
    func selectTableCell()
    func select(deselectionClosure: (() -> Void)?)
}

extension CommonTableCellViewModel {
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

protocol CommonTableCellContainerViewModel: CommonTableCellViewModel {
    var contentViewModel: CommonTableCellViewModel { get }
}

extension CommonTableCellContainerViewModel {
    func select(deselectionClosure: (() -> Void)?) {
        contentViewModel.select(deselectionClosure: deselectionClosure)
    }
}

protocol CommonTableCell {
    func configure(with viewModel: CommonTableCellViewModel)
}

