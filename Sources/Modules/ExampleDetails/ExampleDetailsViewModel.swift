//
//  ExampleDetailsViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

protocol ExampleDetailsViewModel: TableViewModel {
    var mockDataSource: MockDataSource { get }
    var cursor: String? { get set }
    var isLoading: Bool { get set }
    
    init(example: Example)
    
    func handleResponse(_ response: MockDataSourceResponse)
    func updateTableData(animating: Bool)
}

extension ExampleDetailsViewModel {
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
}
