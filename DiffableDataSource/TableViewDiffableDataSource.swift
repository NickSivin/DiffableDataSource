//
//  TableViewDiffableDataSource.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol DiffableDataSection: AnyObject {
    var items: [DiffableDataItem] { get set }
}

protocol DiffableDataItem {
    var tableIdentifier: UUID { get }
}

protocol TableViewDiffableDataNewStateUpdating {
    typealias Section = DiffableDataSection
    typealias Item = DiffableDataItem
    typealias RowAnimation = UITableView.RowAnimation
    
    // Methods updates data by using new snapshot
    func updateData(sections: [Section], rowAnimation: RowAnimation, animating: Bool)
    func updateData(items: [Item], rowAnimation: RowAnimation, animating: Bool)
}

protocol TableViewDiffableDataCurrentStateUpdating {
    typealias SnapshotContext = TableViewDiffableDataSnapshotContext
    typealias Section = DiffableDataSection
    typealias Item = DiffableDataItem
    
    // Methods updates data by using snapshot of current context
    func insertItem(_ item: Item, at index: Int, in section: Int) -> SnapshotContext
    func insertItems(_ items: [Item], at index: Int, in section: Int) -> SnapshotContext
    func appendItem(_ item: Item, in section: Int) -> SnapshotContext
    func appendItems(_ items: [Item], in section: Int) -> SnapshotContext
    func deleteItem(_ item: Item) -> SnapshotContext
    func deleteItems(_ items: [Item]) -> SnapshotContext
    func reloadItem(_ item: Item) -> SnapshotContext
    func reloadItems(_ items: [Item]) -> SnapshotContext
}

protocol TableViewDiffableDataApplying {
    // TODO: Change concrete generic types to protocols or something similar
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, UUID>
    typealias RowAnimation = UITableView.RowAnimation
    func apply(_ snapshot: Snapshot, rowAnimation: RowAnimation, animatingDifferences: Bool)
}

protocol TableViewDiffableDataSource: AnyObject, TableViewDiffableDataNewStateUpdating
                                    & TableViewDiffableDataCurrentStateUpdating
                                    & TableViewDiffableDataApplying {}

extension TableViewDiffableDataSource {
    func updateData(sections: [Section], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        updateData(sections: sections, rowAnimation: rowAnimation, animating: animating)
    }

    func updateData(items: [Item], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        updateData(items: items, rowAnimation: rowAnimation, animating: animating)
    }
}
