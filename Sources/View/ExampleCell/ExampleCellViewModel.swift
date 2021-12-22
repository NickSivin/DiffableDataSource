//
//  ExampleCellViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

class ExampleCellViewModel: CommonTableCellViewModel {
    var reuseIdentifier: String {
        return ExampleCell.reuseIdentifier
    }
    
    var identifier: String {
        return example.identifier
    }
    
    var image: ImageAsset.ImageName {
        return example.image
    }
    
    var title: String? {
        return example.title
    }
    
    private let example: Example
    
    init(example: Example) {
        self.example = example
    }
}
