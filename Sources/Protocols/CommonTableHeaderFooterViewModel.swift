//
//  CommonTableHeaderFooterViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

protocol CommonTableHeaderFooterViewModel: AnyObject {
    var reuseIdentifier: String { get }
}

protocol CommonTableHeaderFooterView {
    func configure(with viewModel: CommonTableHeaderFooterViewModel)
}
