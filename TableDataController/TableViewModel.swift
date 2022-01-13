//
//  TableViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol TableViewModel: AnyObject {
    var tableDataSource: TableViewDiffableDataSource? { get set }
    var sectionViewModels: [TableSectionViewModel] { get }
    var showHeaderAndFooterForEmptySection: Bool { get }
    var isDragAndDropEnabled: Bool { get }
    
    func loadData()
    func canEdit(atIndexPath indexPath: IndexPath) -> Bool
    func commit(editStyle: UITableViewCell.EditingStyle, indexPath: IndexPath)
    func editingStyle(forIndexPath indexPath: IndexPath) -> UITableViewCell.EditingStyle
    func cellViewModelForRow(at indexPath: IndexPath) -> TableCellViewModel?
}

extension TableViewModel {
    var showHeaderAndFooterForEmptySection: Bool {
        return false
    }
    
    var isDragAndDropEnabled: Bool {
        return false
    }
    
    func canEdit(atIndexPath indexPath: IndexPath) -> Bool {
        return false
    }
    
    func commit(editStyle: UITableViewCell.EditingStyle, indexPath: IndexPath) {}
    
    func editingStyle(forIndexPath indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func cellViewModelForRow(at indexPath: IndexPath) -> TableCellViewModel? {
        guard let section = sectionViewModels.element(at: indexPath.section) else { return nil }
        return section.cellViewModels.element(at: indexPath.row)
    }
}
