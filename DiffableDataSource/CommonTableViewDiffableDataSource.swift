//
//  CommonTableViewDiffableDataSource.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

class CommonTableViewDiffableDataSource: BaseTableViewDiffableDataSource<CommonTableViewDiffableDataSource.SectionIdentifier,
                                         CommonTableViewDiffableDataSource.ItemIdentifier>, TableViewDiffableDataSource {
    typealias Section = DiffableDataSection
    typealias Item = DiffableDataItem
    typealias RowAnimation = UITableView.RowAnimation
    typealias SectionIdentifier = Int
    typealias ItemIdentifier = UUID
    
    private var currentContext: SnapshotContext {
        return CommonTableViewDiffableDataSnapshotContext(snapshot: snapshot(), dataSource: self)
    }
    
    private var newContext: SnapshotContext {
        return CommonTableViewDiffableDataSnapshotContext(snapshot: makeNewSnapshot(), dataSource: self)
    }
    
    func apply(_ snapshot: Snapshot, rowAnimation: RowAnimation, animatingDifferences: Bool) {
        defaultRowAnimation = rowAnimation
        apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func updateData(sections: [Section], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        var context = newContext
        sections
            .map { $0.items }
            .enumerated()
            .forEach { section, items in
                context = context.appendItems(items, in: section)
            }
        context.apply(rowAnimation: rowAnimation, animatingDifferences: animating)
    }
    
    func updateData(items: [Item], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        newContext
            .appendItems(items, in: 0)
            .apply(rowAnimation: rowAnimation, animatingDifferences: animating)
    }
    
    func insertItem(_ item: Item, at index: Int, in section: Int) -> SnapshotContext {
        return currentContext.insertItem(item, at: index, in: section)
    }
    
    func insertItems(_ items: [Item], at index: Int, in section: Int) -> SnapshotContext {
        return currentContext.insertItems(items, at: index, in: section)
    }
    
    func appendItem(_ item: Item, in section: Int) -> SnapshotContext {
        return currentContext.appendItem(item, in: section)
    }
    
    func appendItems(_ items: [Item], in section: Int) -> SnapshotContext {
        return currentContext.appendItems(items, in: section)
    }
    
    func deleteItem(_ item: Item) -> SnapshotContext {
        return currentContext.deleteItem(item)
    }
    
    func deleteItems(_ items: [Item]) -> SnapshotContext {
        return currentContext.deleteItems(items)
    }
    
    func reloadItem(_ item: Item) -> SnapshotContext {
        return currentContext.reloadItem(item)
    }
    
    func reloadItems(_ items: [Item]) -> SnapshotContext {
        return currentContext.reloadItems(items)
    }
    
    private func makeNewSnapshot() -> NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier> {
        return NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>()
    }
}
