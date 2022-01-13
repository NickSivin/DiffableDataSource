//
//  ExampleHeaderViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

class ExampleHeaderViewModel: TableHeaderFooterViewModel {
    var reuseIdentifier: String {
        return ExampleHeaderView.reuseIdentifier
    }
    
    let title: String?
    
    init(title: String?) {
        self.title = title
    }
}
