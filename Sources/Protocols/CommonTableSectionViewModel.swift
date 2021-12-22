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
