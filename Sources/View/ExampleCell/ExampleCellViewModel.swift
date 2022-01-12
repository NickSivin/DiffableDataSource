//
//  ExampleCellViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

class ExampleCellViewModel: TableCellViewModel {
    var onDidSelect: (() -> Void)?
    
    var reuseIdentifier: String {
        return ExampleCell.reuseIdentifier
    }
    
    var image: ImageAsset.ImageName? {
        return example.image
    }
    
    var title: String? {
        return example.title
    }
    
    private let example: Example
    
    init(example: Example) {
        self.example = example
    }
    
    func select(deselectionClosure: (() -> Void)?) {
        onDidSelect?()
    }
}
