//
//  TableDataController.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol TableDataControllerDelegate: AnyObject {
    func tableDataController(_ controller: TableDataController, scrollViewDidScroll scrollView: UIScrollView)
}

protocol TableDataController {
    var delegate: TableDataControllerDelegate? { get set }
    var isScrolling: Bool { get }
    init(tableView: UITableView, viewModel: TableViewModel)
}

class CommonTableDataController: NSObject, TableDataController {
    typealias TableDataSource = CommonTableViewDiffableDataSource
    
    weak var delegate: TableDataControllerDelegate?
    
    private(set) var isScrolling = false
    
    private var tableView: UITableView
    private let viewModel: TableViewModel
    
    private lazy var tableDataSource = TableDataSource(tableView: tableView) { [weak self] tableView, indexPath, _ in
        guard let cellViewModel = self?.viewModel.cellViewModelForRow(at: indexPath) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.reuseIdentifier, for: indexPath)
        (cell as? TableCell)?.configure(with: cellViewModel)
        cell.selectionStyle = .none
        return cell
    }
    
    required init(tableView: UITableView, viewModel: TableViewModel) {
        self.tableView = tableView
        self.viewModel = viewModel
        super.init()
        
        self.tableView.backgroundColor = .clear
        self.tableView.separatorColor = .clear
        self.tableView.delegate = self
        self.viewModel.tableDataSource = tableDataSource
    }
}

// MARK: - UITableViewDelegate
extension CommonTableDataController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isScrolling = false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return viewModel.editingStyle(forIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.commit(editStyle: editingStyle, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = viewModel.cellViewModelForRow(at: indexPath)
        DispatchQueue.main.async {
            cellViewModel?.select { [weak tableView] in
                tableView?.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellViewModel = viewModel.cellViewModelForRow(at: indexPath)
        if var cachingCellViewModel = cellViewModel as? CellHeightCaching,
           cachingCellViewModel.cachedHeight == nil {
            cell.layoutIfNeeded()
            cachingCellViewModel.cachedHeight = cell.frame.height
        }
        
        if cell is PaginationCell {
            (viewModel as? PaginationTableViewModel)?.loadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = viewModel.sectionViewModels.element(at: section)
        return section?.headerViewModel != nil ? UITableView.automaticDimension : CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let section = viewModel.sectionViewModels.element(at: section)
        return section?.footerViewModel != nil ? UITableView.automaticDimension : CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height(forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return height(forRowAt: indexPath)
    }
    
    private func height(forRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = viewModel.cellViewModelForRow(at: indexPath)
        if let cachingCellViewModel = cellViewModel as? CellHeightCaching,
           let height = cachingCellViewModel.cachedHeight {
            return height
        }
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.tableDataController(self, scrollViewDidScroll: scrollView)
    }
}
