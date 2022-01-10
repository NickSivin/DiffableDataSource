//
//  TableViewContainer.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol TableViewContainer {
    associatedtype ViewModel: TableViewContainerViewModel
    var tableView: UITableView { get }
    var viewModel: ViewModel { get }
    func makeTableViewDiffableDataSource() -> CommonTableViewDiffableDataSource
}

extension TableViewContainer {
    func makeTableViewDiffableDataSource() -> CommonTableViewDiffableDataSource {
        return CommonTableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cellViewModel = viewModel.cellViewModelForRow(at: indexPath) else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.reuseIdentifier,
                                                     for: indexPath)
            (cell as? TableCell)?.configure(with: cellViewModel)
            cell.selectionStyle = .none
            return cell
        }
    }
}

protocol TableViewContainerViewModel {
    func cellViewModelForRow(at indexPath: IndexPath) -> TableCellViewModel?
}
