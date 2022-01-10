//
//  TableSectionViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

protocol TableSectionViewModel {
    var cellViewModels: [TableCellViewModel] { get set }
    var headerViewModel: TableHeaderFooterViewModel? { get }
    var footerViewModel: TableHeaderFooterViewModel? { get }
}
