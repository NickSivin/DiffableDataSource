//
//  PaginationCellViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

class PaginationCellViewModel: TableCellViewModel {
    var reuseIdentifier: String {
        return PaginationCell.reuseIdentifier
    }
}
