//
//  PaginationDiffableDataItem.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

struct PaginationDiffableDataItem: DiffableDataItem {
    let tableIdentifier = UUID()
    let identifier = UUID().uuidString
}
