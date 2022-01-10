//
//  ExampleListViewModel.swift
//  DiffableDataSource
//

import Foundation

class ExampleListViewModel: TableViewContainerViewModel {
    var dataSource: CommonTableViewDiffableDataSource? {
        didSet {
            setupDataSource()
        }
    }
    
    private func setupDataSource() {
        
    }
    
    func cellViewModelForRow(at indexPath: IndexPath) -> TableCellViewModel? {
        return nil
    }
}
