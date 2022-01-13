//
//  ExampleCellViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

protocol ExampleCellModel {
    var title: String { get }
    var image: ImageAsset.ImageName? { get }
}

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
    
    private let example: ExampleCellModel
    
    init(example: ExampleCellModel) {
        self.example = example
    }
    
    func select(deselectionClosure: (() -> Void)?) {
        onDidSelect?()
    }
}
