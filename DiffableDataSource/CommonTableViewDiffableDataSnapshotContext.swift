//
//  CommonTableViewDiffableDataSnapshotContext.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

struct CommonTableViewDiffableDataSnapshotContext: TableViewDiffableDataSnapshotContext {
    typealias Section = DiffableDataSection
    typealias Item = DiffableDataItem
    typealias RowAnimation = UITableView.RowAnimation
    typealias SectionIdentifier = Int
    typealias ItemIdentifier = UUID
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>
    
    let snapshot: Snapshot
    let dataSource: TableViewDiffableDataApplying
    
    func insertItem(_ item: Item, at index: Int, in section: Int)  -> SnapshotContext {
        return insertItems([item], at: index, in: section)
    }
    
    func insertItems(_ items: [Item], at index: Int, in section: Int) -> SnapshotContext {
        return performChanges { snapshot in
            insertItems(items, at: index, in: section, snapshot: &snapshot)
        }
    }
    
    func appendItem(_ item: Item, in section: Int) -> SnapshotContext {
        return appendItems([item], in: section)
    }
    
    func appendItems(_ items: [Item], in section: Int) -> SnapshotContext {
        return performChanges { snapshot in
            appendSectionIfNeeded(section, snapshot: &snapshot)
            snapshot.appendItems(items.tableIdentifiers, toSection: section)
        }
    }
    
    func deleteItem(_ item: Item) -> SnapshotContext {
        return deleteItems([item])
    }
    
    func deleteItems(_ items: [Item]) -> SnapshotContext {
        return performChanges { snapshot in
            deleteItems(items, snapshot: &snapshot)
        }
    }
    
    func reloadItem(_ item: Item) -> SnapshotContext {
        return reloadItems([item])
    }
    
    func reloadItems(_ items: [Item]) -> SnapshotContext {
        return performChanges { snapshot in
            let itemIdentifiers = items.map { $0.tableIdentifier }
            let existingItems = itemIdentifiers.filter { snapshot.itemIdentifiers.contains($0) }
            snapshot.reloadItems(existingItems)
        }
    }
    
    private func insertItems(_ items: [Item], at index: Int, in section: Int, snapshot: inout Snapshot) {
        let itemIdentifiers = items.map { $0.tableIdentifier }
        appendSectionIfNeeded(section, snapshot: &snapshot)
        deleteExistingItems(itemIdentifiers, in: section, snapshot: &snapshot)
        insertItems(itemIdentifiers, at: index, in: section, snapshot: &snapshot)
    }
    
    private func deleteItems(_ items: [Item], snapshot: inout Snapshot) {
        let sections = Array(Set(items.tableIdentifiers.compactMap { snapshot.sectionIdentifier(containingItem: $0) }))
        snapshot.deleteItems(items.tableIdentifiers)
        sections.forEach { deleteSectionIfNeeded($0, snapshot: &snapshot) }
    }
    
    private func deleteExistingItems(_ itemIdentifiers: [ItemIdentifier], in section: Int, snapshot: inout Snapshot) {
        let sectionItems = snapshot.itemIdentifiers(inSection: section)
        let existingItems = itemIdentifiers.filter { sectionItems.contains($0) }
        if !existingItems.isEmpty {
            snapshot.deleteItems(existingItems)
        }
    }
    
    private func insertItems(_ itemIdentifiers: [ItemIdentifier], at index: Int, in section: Int, snapshot: inout Snapshot) {
        let sectionItems = snapshot.itemIdentifiers(inSection: section)
        let previousItem = sectionItems.element(at: index - 1)
        let nextItem = sectionItems.element(at: index)
        
        if let previousItem = previousItem {
            snapshot.insertItems(itemIdentifiers, afterItem: previousItem)
        } else if let nextItem = nextItem {
            snapshot.insertItems(itemIdentifiers, beforeItem: nextItem)
        } else {
            snapshot.appendItems(itemIdentifiers, toSection: section)
        }
    }
    
    private func appendSectionIfNeeded(_ section: Int, snapshot: inout Snapshot) {
        guard !snapshot.sectionIdentifiers.contains(section) else { return }
        snapshot.appendSections([section])
    }
    
    private func deleteSectionIfNeeded(_ section: Int, snapshot: inout Snapshot) {
        guard snapshot.itemIdentifiers(inSection: section).isEmpty else { return }
        snapshot.deleteSections([section])
    }
    
    private func performChanges(changes: (_ snapshot: inout Snapshot) -> Void) -> SnapshotContext {
        var mutableSnapshot = snapshot
        changes(&mutableSnapshot)
        return CommonTableViewDiffableDataSnapshotContext(snapshot: mutableSnapshot, dataSource: dataSource)
    }
}

private extension Array where Element == DiffableDataItem {
    var tableIdentifiers: [UUID] {
        return map { $0.tableIdentifier }
    }
}
