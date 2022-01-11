//
//  ExampleListViewModel.swift
//  DiffableDataSource
//

import Foundation

class ExampleListViewModel: TableViewModel {
    weak var tableDataSource: TableViewDiffableDataSource?
    
    var sectionViewModels: [TableSectionViewModel] = []
    
    
    
    private func setupDataSource() {
        
    }
}
