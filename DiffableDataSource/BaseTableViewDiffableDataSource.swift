//
//  BaseTableViewDiffableDataSource.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

class BaseTableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>:
    UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>
where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    
    var onDidRequestCanEditRow: ((IndexPath) -> Bool)?
    var onDidRequestEditingStyle: ((IndexPath) -> UITableViewCell.EditingStyle)?
    var onDidRequestTrailingSwipeActionsConfiguration: ((IndexPath) -> UISwipeActionsConfiguration?)?
    var onDidRequestLeadingSwipeActionsConfiguration: ((IndexPath) -> UISwipeActionsConfiguration?)?
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return onDidRequestCanEditRow?(indexPath) ?? false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return onDidRequestEditingStyle?(indexPath) ?? .none
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return onDidRequestTrailingSwipeActionsConfiguration?(indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return onDidRequestLeadingSwipeActionsConfiguration?(indexPath)
    }
}
