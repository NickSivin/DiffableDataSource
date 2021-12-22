//
//  CommonTableViewContainer.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol CommonTableViewContainer {
    var tableView: UITableView { get }
    var viewModel: CommonTableViewContainerViewModel { get }
    func makeTableViewDiffableDataSource() -> CommonTableViewDiffableDataSource
}

extension CommonTableViewContainer {
    func makeTableViewDiffableDataSource() -> CommonTableViewDiffableDataSource {
        return CommonTableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cellViewModel = viewModel.cellViewModelForRow(at: indexPath) else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.reuseIdentifier,
                                                     for: indexPath)
            (cell as? CommonTableCell)?.configure(with: cellViewModel)
            cell.selectionStyle = .none
            return cell
        }
    }
}

protocol CommonTableViewContainerViewModel {
    var sections: [CommonTableSectionViewModel] { get }
    func cellViewModelForRow(at indexPath: IndexPath) -> CommonTableCellViewModel?
}

extension CommonTableViewContainerViewModel {
    func cellViewModelForRow(at indexPath: IndexPath) -> CommonTableCellViewModel? {
        let section = sections.element(at: indexPath.section)
        return section?.cellViewModels.element(at: indexPath.row)
    }
}
