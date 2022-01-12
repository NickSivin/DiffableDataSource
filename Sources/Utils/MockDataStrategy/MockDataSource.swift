//
//  MockDataSource.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

protocol MockDataSource: MockRequestSimulating {
    func getMockData(cursor: String?, completion: @escaping ((MockDataSourceResponse) -> Void))
}
