//
//  TableViewDiffableDataSnapshotContext.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol TableViewDiffableDataSnapshotContext: TableViewDiffableDataCurrentStateUpdating {
    typealias RowAnimation = UITableView.RowAnimation
    
    // TODO: Change concrete generic types to protocols or something similar
    var snapshot: NSDiffableDataSourceSnapshot<Int, UUID> { get }
    var dataSource: TableViewDiffableDataApplying { get }
    func apply(rowAnimation: RowAnimation, animatingDifferences: Bool)
}

extension TableViewDiffableDataSnapshotContext {
    func apply(rowAnimation: RowAnimation = .none, animatingDifferences: Bool = false) {
        dataSource.apply(snapshot, rowAnimation: rowAnimation, animatingDifferences: animatingDifferences)
    }
}
