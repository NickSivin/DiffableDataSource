//
//  ExampleListViewModel.swift
//  DiffableDataSource
//

import Foundation

class ExampleListViewModel: CommonTableViewContainerViewModel {
    var dataSource: CommonTableViewDiffableDataSource? {
        didSet {
            setupDataSource()
        }
    }
    
    private(set) lazy var sections = makeSections()
    
    private func makeSections() -> [CommonTableSectionViewModel] {
        let mainSection = TableSectionViewModel(cellViewModels: [])
        let cellViewModels = 
        return [mainSection]
    }
}
