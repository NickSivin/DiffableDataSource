//
//  CommonTableSectionViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

class CommonTableSectionViewModel: TableSectionViewModel {
    // MARK: - Properties
    var cellViewModels: [TableCellViewModel] = []
    
    let headerViewModel: TableHeaderFooterViewModel?
    let footerViewModel: TableHeaderFooterViewModel?
    
    var numberOfRows: Int {
        return cellViewModels.count
    }
    
    var isEmpty: Bool {
        return cellViewModels.isEmpty
    }
    
    // MARK: - Init
    init(cellViewModels: [TableCellViewModel] = [],
         headerViewModel: TableHeaderFooterViewModel? = nil,
         footerViewModel: TableHeaderFooterViewModel? = nil) {
        self.cellViewModels = cellViewModels
        self.headerViewModel = headerViewModel
        self.footerViewModel = footerViewModel
    }
    
    // MARK: - Public
    func cellViewModelForRow(at index: Int) -> TableCellViewModel? {
        return cellViewModels.element(at: index)
    }
}
