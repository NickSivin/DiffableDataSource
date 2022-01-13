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
        setup()
    }
    
    private func setup() {
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.delegate = self
        if viewModel.isDragAndDropEnabled {
            tableView.dragInteractionEnabled = true
            tableView.dragDelegate = self
            tableView.dropDelegate = self
        }
        viewModel.tableDataSource = tableDataSource
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerViewModel = viewModel.sectionViewModels.element(at: section)?.headerViewModel,
              let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewModel.reuseIdentifier) else {
                  return nil
              }
        if !viewModel.showHeaderAndFooterForEmptySection,
           (viewModel.sectionViewModels.element(at: section)?.cellViewModels.count ?? 0) == 0 {
            return nil
        }
        (header as? TableHeaderFooterView)?.configure(with: headerViewModel)
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerViewModel = viewModel.sectionViewModels.element(at: section)?.footerViewModel,
              let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerViewModel.reuseIdentifier) else {
                  return nil
              }
        if !viewModel.showHeaderAndFooterForEmptySection,
           (viewModel.sectionViewModels.element(at: section)?.cellViewModels.count ?? 0) == 0 {
            return nil
        }
        (footer as? TableHeaderFooterView)?.configure(with: footerViewModel)
        return footer
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

// MARK: - UITableViewDragDelegate
extension CommonTableDataController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView,
                   itemsForBeginning session: UIDragSession,
                   at indexPath: IndexPath) -> [UIDragItem] {
        guard let viewModel = viewModel as? DragAndDroppable,
              viewModel.canDrag(atIndexPath: indexPath, location: session.location(in: tableView)),
              let id = viewModel.itemID(atIndexPath: indexPath) else { return [] }
        let itemProvider = NSItemProvider(object: id as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView,
                   dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        parameters.backgroundColor = .clear
        return parameters
    }
}

// MARK: - UITableViewDropDelegate
extension CommonTableDataController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let viewModel = viewModel as? DragAndDroppable else { return }
        let insertionIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            insertionIndexPath = indexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section) - 1
            insertionIndexPath = IndexPath(row: row, section: section)
        }
        
        for item in coordinator.items {
            guard let sourceIndexPath = item.sourceIndexPath else { continue }
            item.dragItem.itemProvider.loadObject(ofClass: NSString.self) { object, _ in
                DispatchQueue.main.async {
                    guard let id = object as? String else { return }
                    viewModel.moveElement(withID: id, from: sourceIndexPath, to: insertionIndexPath)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView,
                   dropSessionDidUpdate session: UIDropSession,
                   withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        guard let viewModel = viewModel as? DragAndDroppable, let indexPath = destinationIndexPath,
              viewModel.canDrop(toIndexPath: indexPath, location: session.location(in: tableView)) else {
                  return UITableViewDropProposal(operation: .cancel)
              }
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}
