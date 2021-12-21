//
//  CommonTableViewDiffableDataSource.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol CommonDiffableDataItem {
    var identifier: String { get }
    var section: Int { get }
}

class CommonTableViewDiffableDataSource: BaseTableViewDiffableDataSource <CommonTableViewDiffableDataSource.SectionIdentifier,
                                         CommonTableViewDiffableDataSource.ItemIdentifier> {
    typealias Item = CommonDiffableDataItem
    typealias RowAnimation = UITableView.RowAnimation
    typealias SectionIdentifier = Int
    typealias ItemIdentifier = String
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>
    
    func reloadData(allItems: [Item], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        snapshotContext(rowAnimation: rowAnimation, animatingDifferences: animating) { snapshot in
            snapshot.deleteAllItems()
            appendItems(allItems, snapshot: &snapshot)
        }
    }
    
    func updateData(allItems: [Item], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        snapshotContext(rowAnimation: rowAnimation, animatingDifferences: animating) { snapshot in
            updateItems(allItems, snapshot: &snapshot)
        }
    }
    
    func insertItem(_ item: Item, at index: Int, rowAnimation: RowAnimation = .none, animating: Bool = false) {
        insertItems([item], at: index, rowAnimation: rowAnimation, animating: animating)
    }
    
    func insertItems(_ items: [Item], at index: Int, rowAnimation: RowAnimation = .none, animating: Bool = false) {
        snapshotContext(rowAnimation: rowAnimation, animatingDifferences: animating) { snapshot in
            insertItems(items, at: index, snapshot: &snapshot)
        }
    }
    
    func appendItem(_ item: Item, rowAnimation: RowAnimation = .none, animating: Bool = false) {
        appendItems([item], rowAnimation: rowAnimation, animating: animating)
    }
    
    func appendItems(_ items: [Item], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        snapshotContext(rowAnimation: rowAnimation, animatingDifferences: animating) { snapshot in
            appendItems(items, snapshot: &snapshot)
        }
    }
    
    func deleteItem(_ item: Item, rowAnimation: RowAnimation = .none, animating: Bool = false) {
        deleteItems([item], rowAnimation: rowAnimation, animating: animating)
    }
    
    func deleteItems(_ items: [Item], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        snapshotContext(rowAnimation: rowAnimation, animatingDifferences: animating) { snapshot in
            deleteItems(items, snapshot: &snapshot)
        }
    }
    
    func reloadItem(_ item: Item, rowAnimation: RowAnimation = .none, animating: Bool = false) {
        reloadItems([item], rowAnimation: rowAnimation, animating: animating)
    }
    
    func reloadItems(_ items: [Item], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        snapshotContext(rowAnimation: rowAnimation, animatingDifferences: animating) { snapshot in
            let itemIdentifiers = items.map { $0.identifier }
            let existingItems = itemIdentifiers.filter { snapshot.itemIdentifiers.contains($0) }
            snapshot.reloadItems(existingItems)
        }
    }
    
    private func insertItems(_ items: [Item], at index: Int, snapshot: inout Snapshot) {
        iterateSections(items) { section, itemIdentifiers in
            appendSectionIfNeeded(section, snapshot: &snapshot)
            deleteExistingItems(itemIdentifiers, in: section, snapshot: &snapshot)
            insertItems(itemIdentifiers, at: index, in: section, snapshot: &snapshot)
        }
    }
    
    private func appendItems(_ items: [Item], snapshot: inout Snapshot) {
        iterateSections(items) { section, itemIdentifiers in
            appendSectionIfNeeded(section, snapshot: &snapshot)
            appendMissingItems(itemIdentifiers, in: section, snapshot: &snapshot)
            reloadExistingItems(itemIdentifiers, in: section, snapshot: &snapshot)
        }
    }
    
    private func deleteItems(_ items: [Item], snapshot: inout Snapshot) {
        iterateSections(items) { section, itemIdentifiers in
            snapshot.deleteItems(itemIdentifiers)
            deleteSectionIfNeeded(section, snapshot: &snapshot)
        }
    }
    
    private func updateItems(_ items: [Item], snapshot: inout Snapshot) {
        iterateSections(items) { section, itemIdentifiers in
            appendSectionIfNeeded(section, snapshot: &snapshot)
            updateItems(itemIdentifiers, in: section, snapshot: &snapshot)
            deleteSectionIfNeeded(section, snapshot: &snapshot)
        }
    }
    
    private func updateItems(_ itemIdentifiers: [ItemIdentifier], in section: Int, snapshot: inout Snapshot) {
        appendMissingItems(itemIdentifiers, in: section, snapshot: &snapshot)
        reloadExistingItems(itemIdentifiers, in: section, snapshot: &snapshot)
        deleteExtraItems(itemIdentifiers, in: section, snapshot: &snapshot)
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
    
    private func appendMissingItems(_ itemIdentifiers: [ItemIdentifier], in section: Int, snapshot: inout Snapshot) {
        let sectionItems = snapshot.itemIdentifiers(inSection: section)
        let newItems = itemIdentifiers.filter { !sectionItems.contains($0) }
        snapshot.appendItems(newItems, toSection: section)
    }
    
    private func reloadExistingItems(_ itemIdentifiers: [ItemIdentifier], in section: Int, snapshot: inout Snapshot) {
        let sectionItems = snapshot.itemIdentifiers(inSection: section)
        let existingItems = itemIdentifiers.filter { sectionItems.contains($0) }
        snapshot.reloadItems(existingItems)
    }
    
    private func deleteExtraItems(_ itemIdentifiers: [ItemIdentifier], in section: Int, snapshot: inout Snapshot) {
        let sectionItems = snapshot.itemIdentifiers(inSection: section)
        let outdatedItems = sectionItems.filter { !itemIdentifiers.contains($0) }
        snapshot.deleteItems(outdatedItems)
    }
    
    private func appendSectionIfNeeded(_ section: Int, snapshot: inout Snapshot) {
        guard !snapshot.sectionIdentifiers.contains(section) else { return }
        snapshot.appendSections([section])
    }
    
    private func deleteSectionIfNeeded(_ section: Int, snapshot: inout Snapshot) {
        guard snapshot.itemIdentifiers(inSection: section).isEmpty else { return }
        snapshot.deleteSections([section])
    }
    
    private func iterateSections(_ items: [Item], iteration: (SectionIdentifier, [ItemIdentifier]) -> Void) {
        let groupedItems = Dictionary(grouping: items, by: { $0.section })
        groupedItems.keys.forEach { section in
            guard let items = groupedItems[section] else { return }
            iteration(section, items.map { $0.identifier })
        }
    }
    
    private func snapshotContext(rowAnimation: RowAnimation,
                                 animatingDifferences: Bool = true,
                                 changes: (_ snapshot: inout Snapshot) -> Void) {
        defaultRowAnimation = rowAnimation
        
        var snapshot = snapshot()
        changes(&snapshot)
        apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
