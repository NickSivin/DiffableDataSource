//
//  CommonTableSectionViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

protocol CommonTableSectionViewModel: AnyObject {
    var cellViewModels: [CommonTableCellViewModel] { get set }
    var headerViewModel: CommonTableHeaderFooterViewModel? { get }
    var footerViewModel: CommonTableHeaderFooterViewModel? { get }
}

class AnyTableSectionViewModel: CommonTableSectionViewModel {
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
    
    // MARK: - Init
    init(headerViewModel: CommonTableHeaderFooterViewModel? = nil,
         footerViewModel: CommonTableHeaderFooterViewModel? = nil) {
        self.headerViewModel = headerViewModel
        self.footerViewModel = footerViewModel
    }
    
    // MARK: - Public
    func cellViewModelForRow(at index: Int) -> CommonTableCellViewModel? {
        return cellViewModels.element(at: index)
    }
}
