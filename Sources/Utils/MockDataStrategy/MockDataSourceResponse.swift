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
    let data: [MockDataSection]
}

class MockDataSection: DiffableDataSection {
    let title: String?
    var items: [DiffableDataItem]
    
    var mockDataItems: [MockDataItem] {
        return items.compactMap { $0 as? MockDataItem }
    }
    
    init(title: String? = nil, items: [MockDataItem]) {
        self.title = title
        self.items = items
    }
}

struct MockDataItem: DiffableDataItem {
    let tableIdentifier = UUID()

    let identifier: String
    let title: String
    let image: ImageAsset.ImageName?
    
    init(identifier: String = UUID().uuidString,
         title: String,
         image: ImageAsset.ImageName? = nil) {
        self.identifier = identifier
        self.title = title
        self.image = image
    }
}

extension MockDataItem: ExampleCellModel {}
