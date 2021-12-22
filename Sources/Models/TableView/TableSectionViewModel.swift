//
//  TableSectionViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

class TableSectionViewModel: CommonTableSectionViewModel, CommonDiffableDataSection {
    // MARK: - Properties
    var cellViewModels: [CommonTableCellViewModel] = []
    
    let headerViewModel: CommonTableHeaderFooterViewModel?
    let footerViewModel: CommonTableHeaderFooterViewModel?
    
    var numberOfRows: Int {
        return cellViewModels.count
    }
    
    var isEmpty: Bool {
        return cellViewModels.isEmpty
    }
    
    var diffableDataItems: [CommonDiffableDataItem] {
        return cellViewModels
    }
    
    // MARK: - Init
    init(cellViewModels: [CommonTableCellViewModel] = [],
         headerViewModel: CommonTableHeaderFooterViewModel? = nil,
         footerViewModel: CommonTableHeaderFooterViewModel? = nil) {
        self.cellViewModels = cellViewModels
        self.headerViewModel = headerViewModel
        self.footerViewModel = footerViewModel
    }
    
    // MARK: - Public
    func cellViewModelForRow(at index: Int) -> CommonTableCellViewModel? {
        return cellViewModels.element(at: index)
    }
}
