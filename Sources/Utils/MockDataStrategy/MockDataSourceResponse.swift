//
//  MockDataSourceResponse.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

struct MockDataSourceResponse {
    let cursor: String
    let hasMoreData: Bool
    let data: [Example]
}
