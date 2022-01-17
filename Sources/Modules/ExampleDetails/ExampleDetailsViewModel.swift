//
//  ExampleDetailsViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

protocol ExampleDetailsViewModel: TableViewModel {
    var onDidUpdate: (() -> Void)? { get set }
    var profileHeaderViewModel: ProfileHeaderViewModel? { get }
}
