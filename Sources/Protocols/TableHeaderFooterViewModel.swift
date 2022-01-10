//
//  TableHeaderFooterViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

protocol TableHeaderFooterViewModel: AnyObject {
    var reuseIdentifier: String { get }
}

protocol TableHeaderFooterView {
    func configure(with viewModel: TableHeaderFooterViewModel)
}
