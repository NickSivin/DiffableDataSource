//
//  DragAndDropMockDataSource.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

class DragAndDropMockDataSource: MockDataSource {
    func getMockData(cursor: String?, completion: @escaping ((MockDataSourceResponse) -> Void)) {
        let response = MockDataSourceResponse(cursor: "", hasMoreData: false, data: makeMockDataSections())
        completion(response)
    }
    
    private func makeMockDataSections() -> [MockDataSection] {
        return Array(1...5).map { MockDataSection(title: "Section \(String($0))", items: makeMockDataItems()) }
    }
    
    private func makeMockDataItems() -> [MockDataItem] {
        return Array(1...30).map { MockDataItem(title: "Item \(String($0))") }
    }
}
