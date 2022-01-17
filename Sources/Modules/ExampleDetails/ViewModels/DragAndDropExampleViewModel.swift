//
//  DragAndDropExampleViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

class DragAndDropExampleViewModel: ExampleDetailsViewModel, DragAndDroppable {
    var onDidUpdate: (() -> Void)?
    var profileHeaderViewModel: ProfileHeaderViewModel?
    
    var tableDataSource: TableViewDiffableDataSource?
    var sectionViewModels: [TableSectionViewModel] = []
    var sections: [DiffableDataSection] = []
    
    private let mockDataSource = DragAndDropMockDataSource()
    private var cursor: String?
    private var isLoading = false
    
    var isDragAndDropEnabled: Bool {
        return true
    }
    
    private var mockDataSections: [MockDataSection] {
        return sections.compactMap { $0 as? MockDataSection }
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
    
    func handleResponse(_ response: MockDataSourceResponse) {
        cursor = response.cursor
        sections = response.data
    }
    
    func updateTableData(animating: Bool) {
        sectionViewModels = mockDataSections.map { section in
            let cellViewModels = section.mockDataItems.map { ExampleCellViewModel(example: $0) }
            let headerViewModel = ExampleHeaderViewModel(title: section.title)
            return CommonTableSectionViewModel(cellViewModels: cellViewModels, headerViewModel: headerViewModel)
        }
        
        tableDataSource?.updateData(sections: sections, rowAnimation: .none, animating: false)
    }
}
