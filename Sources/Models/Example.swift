//
//  Example.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

struct Example {
    let identifier: String
    let image: ImageAsset.ImageName
    let title: String
    let type: ExampleType
}

enum ExampleType {
    case pagination
    case dragAndDrop
}
