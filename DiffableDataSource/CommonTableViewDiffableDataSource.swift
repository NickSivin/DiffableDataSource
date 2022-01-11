//
//  CommonTableViewDiffableDataSource.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol DiffableDataSection: AnyObject {
    var diffableDataItems: [DiffableDataItem] { get set }
}

protocol DiffableDataItem: AnyObject {
    var identifier: String { get }
    var tableIdentifier: UUID { get }
}

class CommonTableViewDiffableDataSource: BaseTableViewDiffableDataSource<CommonTableViewDiffableDataSource.SectionIdentifier,
                                         CommonTableViewDiffableDataSource.ItemIdentifier>, TableViewDiffableDataSource {
    typealias Section = DiffableDataSection
    typealias Item = DiffableDataItem
    typealias RowAnimation = UITableView.RowAnimation
    typealias SectionIdentifier = Int
    typealias ItemIdentifier = UUID
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>
    
    func updateData(sections: [Section], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        snapshotContext(rowAnimation: rowAnimation, isCurrentState: false, animatingDifferences: animating) { snapshot in
            sections
                .map { $0.diffableDataItems }
                .enumerated()
                .forEach { section, items in
                    appendSectionIfNeeded(section, snapshot: &snapshot)
                    snapshot.appendItems(items.tableIdentifiers, toSection: section)
            }
        }
    }
    
    func reloadData(sections: [Section], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        snapshotContext(rowAnimation: rowAnimation, animatingDifferences: animating) { snapshot in
            snapshot.deleteAllItems()
            appendItems(at: sections, snapshot: &snapshot)
        }
    }
    
    func insertItem(_ item: Item, at index: Int, in section: Int, rowAnimation: RowAnimation = .none, animating: Bool = false) {
        insertItems([item], at: index, in: section, rowAnimation: rowAnimation, animating: animating)
    }
    
    func insertItems(_ items: [Item], at index: Int, in section: Int, rowAnimation: RowAnimation = .none, animating: Bool = false) {
        snapshotContext(rowAnimation: rowAnimation, animatingDifferences: animating) { snapshot in
            insertItems(items, at: index, in: section, snapshot: &snapshot)
        }
    }
    
    func appendItem(_ item: Item, in section: Int, rowAnimation: RowAnimation = .none, animating: Bool = false) {
        appendItems([item], in: section, rowAnimation: rowAnimation, animating: animating)
    }
    
    func appendItems(_ items: [Item], in section: Int, rowAnimation: RowAnimation = .none, animating: Bool = false) {
        snapshotContext(rowAnimation: rowAnimation, animatingDifferences: animating) { snapshot in
            snapshot.appendItems(items.tableIdentifiers, toSection: section)
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
    
    private func appendItems(at sections: [Section], snapshot: inout Snapshot) {
        sections
            .map { $0.diffableDataItems }
            .enumerated()
            .forEach { section, items in
                appendSectionIfNeeded(section, snapshot: &snapshot)
                appendMissingItems(items.tableIdentifiers, in: section, snapshot: &snapshot)
                reloadExistingItems(items.tableIdentifiers, in: section, snapshot: &snapshot)
        }
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
    
    private func snapshotContext(rowAnimation: RowAnimation,
                                 isCurrentState: Bool = true,
                                 animatingDifferences: Bool = true,
                                 changes: (_ snapshot: inout Snapshot) -> Void) {
        defaultRowAnimation = rowAnimation
        
        var snapshot = isCurrentState ? snapshot() : makeNewSnapshot()
        changes(&snapshot)
        apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func makeNewSnapshot() -> NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier> {
        return NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>()
    }
}

private extension Array where Element == DiffableDataItem {
    var tableIdentifiers: [UUID] {
        return map { $0.tableIdentifier }
    }
}
