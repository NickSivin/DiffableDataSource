//
//  Example.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

struct Example: DiffableDataItem {
    let tableIdentifier = UUID()
    
    let identifier: String
    let image: ImageAsset.ImageName?
    let title: String
    let type: ExampleType
    
    init(identifier: String = UUID().uuidString,
         image: ImageAsset.ImageName? = nil,
         title: String,
         type: ExampleType) {
        self.identifier = identifier
        self.image = image
        self.title = title
        self.type = type
    }
}
