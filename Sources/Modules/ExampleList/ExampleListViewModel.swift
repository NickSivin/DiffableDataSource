//
//  ExampleListViewModel.swift
//  DiffableDataSource
//

import Foundation

protocol ExampleListViewModelDelegate: AnyObject {
    func exampleListViewModel(_ viewModel: ExampleListViewModel, didSelectExample example: Example)
}

class ExampleListViewModel: TableViewModel {
    weak var delegate: ExampleListViewModelDelegate?
    weak var tableDataSource: TableViewDiffableDataSource?
    
    var sectionViewModels: [TableSectionViewModel] = []
    
    private let factory = ExampleListFactory()
    private var examples: [Example] = []
    
    func loadData() {
        examples = factory.makeExamples()
        updateTableData()
    }
    
    private func updateTableData() {
        let cellViewModels = examples.map { example -> ExampleCellViewModel in
            let cellViewModel = ExampleCellViewModel(example: example)
            cellViewModel.onDidSelect = { [weak self] in
                guard let self = self else { return }
                self.delegate?.exampleListViewModel(self, didSelectExample: example)
            }
            return cellViewModel
        }
        sectionViewModels = [CommonTableSectionViewModel(cellViewModels: cellViewModels)]
        
        tableDataSource?.updateData(items: examples, rowAnimation: .none, animating: true)
    }
}
