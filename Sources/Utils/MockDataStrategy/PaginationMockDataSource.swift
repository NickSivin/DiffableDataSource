//
//  PaginationMockDataSource.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

private enum Constants {
    static let elementsPerRequestCount = 30
    static let availableElementsCount = elementsPerRequestCount * 4
}

class PaginationMockDataSource: MockDataSource {
    func getMockData(cursor: String?, completion: @escaping ((MockDataSourceResponse) -> Void)) {
        simulateRequest { [weak self] in
            guard let self = self else { return }
            let response = self.makeMockData(cursor: cursor)
            completion(response)
        }
    }
    
    private func makeMockData(cursor: String?) -> MockDataSourceResponse {
        let index = findIndex(for: cursor)
        let lastIndex = min(index + Constants.elementsPerRequestCount, Constants.availableElementsCount - 1)
        let indices = Array(index..<lastIndex)
        
        let data = indices.map { Example(identifier: String($0),
                                         title: String($0) + " Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                                         type: .pagination) }
        let newCursorIndex = lastIndex + 1
        let newCursor = String(newCursorIndex)
        let hasMoreData = newCursorIndex < Constants.availableElementsCount
        return MockDataSourceResponse(cursor: newCursor, hasMoreData: hasMoreData, data: data)
    }
    
    private func findIndex(for cursor: String?) -> Int {
        guard let cursor = cursor, let index = Int(cursor) else { return 0 }
        return index
    }
}
