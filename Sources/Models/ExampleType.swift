//
//  ExampleType.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

enum ExampleType {
    case pagination
    case dragAndDrop
}

extension ExampleType {
    var mockDataSource: MockDataSource {
        switch self {
        case .pagination:
            return PaginationMockDataSource()
        case .dragAndDrop:
            return PaginationMockDataSource()
        }
    }
}
