//
//  TableViewDiffableDataSource.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol TableViewDiffableDataSource: AnyObject {
    typealias Section = DiffableDataSection
    typealias Item = DiffableDataItem
    typealias RowAnimation = UITableView.RowAnimation
    
    func updateData(sections: [Section], rowAnimation: RowAnimation, animating: Bool)
    func reloadData(sections: [Section], rowAnimation: RowAnimation, animating: Bool)
    func insertItem(_ item: Item, at index: Int, in section: Int, rowAnimation: RowAnimation, animating: Bool)
    func insertItems(_ items: [Item], at index: Int, in section: Int, rowAnimation: RowAnimation, animating: Bool)
    func appendItem(_ item: Item, in section: Int, rowAnimation: RowAnimation, animating: Bool)
    func appendItems(_ items: [Item], in section: Int, rowAnimation: RowAnimation, animating: Bool)
    func deleteItem(_ item: Item, rowAnimation: RowAnimation, animating: Bool)
    func deleteItems(_ items: [Item], rowAnimation: RowAnimation, animating: Bool)
    func reloadItem(_ item: Item, rowAnimation: RowAnimation, animating: Bool)
    func reloadItems(_ items: [Item], rowAnimation: RowAnimation, animating: Bool)
}

extension TableViewDiffableDataSource {
    func updateData(sections: [Section], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        updateData(sections: sections, rowAnimation: rowAnimation, animating: animating)
    }
    
    func reloadData(sections: [Section], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        reloadData(sections: sections, rowAnimation: rowAnimation, animating: animating)
    }
    
    func insertItem(_ item: Item, at index: Int, in section: Int, rowAnimation: RowAnimation = .none, animating: Bool = false) {
        insertItem(item, at: index, in: section, rowAnimation: rowAnimation, animating: animating)
    }
    
    func insertItems(_ items: [Item], at index: Int, in section: Int, rowAnimation: RowAnimation = .none, animating: Bool = false) {
        insertItems(items, at: index, in: section, rowAnimation: rowAnimation, animating: animating)
    }
    
    func appendItem(_ item: Item, in section: Int, rowAnimation: RowAnimation = .none, animating: Bool = false) {
        appendItem(item, in: section, rowAnimation: rowAnimation, animating: animating)
    }
    
    func appendItems(_ items: [Item], in section: Int, rowAnimation: RowAnimation = .none, animating: Bool = false) {
        appendItems(items, in: section, rowAnimation: rowAnimation, animating: animating)
    }
    
    func deleteItem(_ item: Item, rowAnimation: RowAnimation = .none, animating: Bool = false) {
        deleteItem(item, rowAnimation: rowAnimation, animating: animating)
    }
    
    func deleteItems(_ items: [Item], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        deleteItems(items, rowAnimation: rowAnimation, animating: animating)
    }
    
    func reloadItem(_ item: Item, rowAnimation: RowAnimation = .none, animating: Bool = false) {
        reloadItem(item, rowAnimation: rowAnimation, animating: animating)
    }
    
    func reloadItems(_ items: [Item], rowAnimation: RowAnimation = .none, animating: Bool = false) {
        reloadItems(items, rowAnimation: rowAnimation, animating: animating)
    }
}
