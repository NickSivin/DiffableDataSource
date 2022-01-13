//
//  PaginationExampleViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

class PaginationExampleViewModel: ExampleDetailsViewModel, PaginationTableViewModel {
    var tableDataSource: TableViewDiffableDataSource?
    var sectionViewModels: [TableSectionViewModel] = []
    
    let mockDataSource: MockDataSource
    var cursor: String?
    var isLoading = false
    
    private var hasMoreData = true
    private var items: [MockDataItem] = []
    private let paginationItem = PaginationDiffableDataItem()
    
    required init(example: Example) {
        self.mockDataSource = example.type.mockDataSource
    }
    
    func handleResponse(_ response: MockDataSourceResponse) {
        hasMoreData = response.hasMoreData
        cursor = response.cursor
        items.append(contentsOf: response.data.first?.mockDataItems ?? [])
    }
    
    func updateTableData(animating: Bool) {
        var cellViewModels: [TableCellViewModel] = items.map { ExampleCellViewModel(example: $0) }
        var diffableDataItems: [DiffableDataItem] = items
        if hasMoreData {
            cellViewModels.append(PaginationCellViewModel())
            diffableDataItems.append(paginationItem)
        }
        sectionViewModels = [CommonTableSectionViewModel(cellViewModels: cellViewModels)]
        
        tableDataSource?.updateData(items: diffableDataItems, rowAnimation: .fade, animating: animating)
    }
}
