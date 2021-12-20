//
//  ConfigurableView.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

protocol ConfigurableView {
    func configure(with viewModel: ConfigurableViewModel)
}
