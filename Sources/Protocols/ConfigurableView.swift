//
//  ConfigurableView.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

protocol ConfigurableView {
    associatedtype ViewModel: ConfigurableViewModel
    func configure(with viewModel: ViewModel)
    func prepareForReuse()
}

extension ConfigurableView {
    func prepareForReuse() {}
}
