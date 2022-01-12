//
//  ExampleListFactory.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

struct ExampleListFactory {
    func makeExamples() -> [Example] {
        return [
            Example(image: .pagination, title: Localized.exampleDetails.string(forKey: .pagination), type: .pagination)
        ]
    }
}
