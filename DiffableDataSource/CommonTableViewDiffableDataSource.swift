//
//  CommonTableViewDiffableDataSource.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol DiffableDataSection {
    var diffableDataItems: [DiffableDataItem] { get }
}

protocol DiffableDataItem {
    var identifier: String { get }
}

class CommonTableViewDiffableDataSource: BaseTableViewDiffableDataSource <CommonTableViewDiffableDataSource.SectionIdentifier,
                                         CommonTableViewDiffableDataSource.ItemIdentifier> {
    typealias Section = DiffableDataSection
    typealias Item = DiffableDataItem
    typealias RowAnimation = UITableView.RowAnimation
    typealias SectionIdentifier = Int
    typealias ItemIdentifier = String
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>
    
    func updateData(allSections: [Section], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        snapshotContext(rowAnimation: rowAnimation, isCurrentState: false, animatingDifferences: animating) { snapshot in
            allSections
                .map { $0.diffableDataItems }
                .enumerated()
                .forEach { section, items in
                    appendSectionIfNeeded(section, snapshot: &snapshot)
                    snapshot.appendItems(items.identifiers, toSection: section)
            }
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
            snapshot.appendItems(items.identifiers, toSection: section)
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
    
    private func insertItems(_ items: [Item], at index: Int, in section: Int, snapshot: inout Snapshot) {
        let itemIdentifiers = items.map { $0.identifier }
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
                appendMissingItems(items.identifiers, in: section, snapshot: &snapshot)
                reloadExistingItems(items.identifiers, in: section, snapshot: &snapshot)
        }
    }
    
    private func deleteItems(_ items: [Item], snapshot: inout Snapshot) {
        let sections = Array(Set(items.identifiers.compactMap { snapshot.sectionIdentifier(containingItem: $0) }))
        snapshot.deleteItems(items.identifiers)
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
    var identifiers: [String] {
        return map { $0.identifier }
    }
}
