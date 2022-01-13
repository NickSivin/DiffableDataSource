//
//  DragAndDropExampleViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

class DragAndDropExampleViewModel: ExampleDetailsViewModel, DragAndDroppable {
    var tableDataSource: TableViewDiffableDataSource?
    var sectionViewModels: [TableSectionViewModel] = []
    var sections: [DiffableDataSection] = []
    
    let mockDataSource: MockDataSource
    var cursor: String?
    var isLoading = false
    
    var isDragAndDropEnabled: Bool {
        return true
    }
    
    private var mockDataSections: [MockDataSection] {
        return sections.compactMap { $0 as? MockDataSection }
    }
    
    required init(example: Example) {
        self.mockDataSource = example.type.mockDataSource
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
