//
//  PaginationExampleViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

class PaginationExampleViewModel: ExampleDetailsViewModel, PaginationTableViewModel {
    var onDidUpdate: (() -> Void)?
    var profileHeaderViewModel: ProfileHeaderViewModel?
    
    var tableDataSource: TableViewDiffableDataSource?
    var sectionViewModels: [TableSectionViewModel] = []
    
    private let mockDataSource = PaginationMockDataSource()
    private var cursor: String?
    
    private var isLoading = false
    private var hasMoreData = true
    
    private var items: [MockDataItem] = []
    private let paginationItem = PaginationDiffableDataItem()
    
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
