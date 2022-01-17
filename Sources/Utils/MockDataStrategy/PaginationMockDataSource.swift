//
//  PaginationMockDataSource.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import CoreGraphics

private enum Constants {
    static let elementsPerRequestCount = 30
    static let availableElementsCount = elementsPerRequestCount * 4
}

class PaginationMockDataSource: MockDataSource {
    func getMockData(cursor: String?, completion: @escaping ((MockDataSourceResponse) -> Void)) {
        let delay: CGFloat = cursor == nil ? 0 : 2
        simulateRequest(delay: delay) { [weak self] in
            guard let self = self else { return }
            let response = self.makeMockData(cursor: cursor)
            completion(response)
        }
    }
    
    private func makeMockData(cursor: String?) -> MockDataSourceResponse {
        let index = findIndex(for: cursor)
        let lastIndex = min(index + Constants.elementsPerRequestCount - 1, Constants.availableElementsCount - 1)
        let indices = Array(index...lastIndex)
        
        let newCursorIndex = lastIndex + 1
        let newCursor = String(newCursorIndex)
        let hasMoreData = newCursorIndex < Constants.availableElementsCount
        
        let items = indices.map { MockDataItem(identifier: String($0), title: "Item \(String($0 + 1))") }
        let sections = [MockDataSection(items: items)]
        
        return MockDataSourceResponse(cursor: newCursor, hasMoreData: hasMoreData, data: sections)
    }
    
    private func findIndex(for cursor: String?) -> Int {
        guard let cursor = cursor, let index = Int(cursor) else { return 0 }
        return index
    }
}
