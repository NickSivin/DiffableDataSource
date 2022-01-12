//
//  ExampleDetailsViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

class ExampleDetailsViewModel: PaginationTableViewModel {
    var tableDataSource: TableViewDiffableDataSource?
    var sectionViewModels: [TableSectionViewModel] = []
    var hasMoreData = true
    
    private let mockDataSource: MockDataSource
    private var cursor: String?
    private var isLoading = false
    private var examples: [Example] = []
    private let paginationItem = PaginationDiffableDataItem()
    
    init(mockDataSource: MockDataSource) {
        self.mockDataSource = mockDataSource
    }
    
    func loadData() {
        guard !isLoading else { return }
        isLoading = true
        mockDataSource.getMockData(cursor: cursor) { [weak self] response in
            guard let self = self else { return }
            self.isLoading = false
            self.handleResponse(response)
            self.updateTableData(animating: !self.sectionViewModels.isEmpty)
        }
    }
    
    private func handleResponse(_ response: MockDataSourceResponse) {
        hasMoreData = response.hasMoreData
        cursor = response.cursor
        examples.append(contentsOf: response.data)
    }
    
    private func updateTableData(animating: Bool) {
        var cellViewModels: [TableCellViewModel] = examples.map { ExampleCellViewModel(example: $0) }
        var diffableDataItems: [DiffableDataItem] = examples
        if hasMoreData {
            cellViewModels.append(PaginationCellViewModel())
            diffableDataItems.append(paginationItem)
        }
        sectionViewModels = [CommonTableSectionViewModel(cellViewModels: cellViewModels)]
        
        tableDataSource?.updateData(items: diffableDataItems, rowAnimation: .fade, animating: animating)
    }
}
