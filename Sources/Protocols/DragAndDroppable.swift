//
//  DragAndDroppable.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol DragAndDroppable {
    var sections: [DiffableDataSection] { get }
    func itemID(atIndexPath indexPath: IndexPath) -> String?
    func moveElement(withID id: String, from indexPath: IndexPath, to finalIndexPath: IndexPath)
    func didMoveElement(from indexPath: IndexPath, to finalIndexPath: IndexPath)
    func canDrag(atIndexPath indexPath: IndexPath, location: CGPoint) -> Bool
    func canDrop(toIndexPath indexPath: IndexPath, location: CGPoint) -> Bool
}

extension DragAndDroppable where Self: TableViewModel {
    func didMoveElement(from indexPath: IndexPath, to finalIndexPath: IndexPath) {}
    
    func canDrag(atIndexPath indexPath: IndexPath, location: CGPoint) -> Bool {
        return true
    }
    
    func canDrop(toIndexPath indexPath: IndexPath, location: CGPoint) -> Bool {
        return true
    }
    
    func itemID(atIndexPath indexPath: IndexPath) -> String? {
        let section = sections.element(at: indexPath.section)
        let item = section?.items.element(at: indexPath.row)
        return item?.identifier
    }
    
    func moveElement(withID id: String, from indexPath: IndexPath, to finalIndexPath: IndexPath) {
        moveCellViewModel(from: indexPath, to: finalIndexPath)
        moveItem(from: indexPath, to: finalIndexPath)
        tableDataSource?.updateData(sections: sections, rowAnimation: .none, animating: false)
        didMoveElement(from: indexPath, to: finalIndexPath)
    }
    
    private func moveCellViewModel(from indexPath: IndexPath, to finalIndexPath: IndexPath) {
        guard let section = sectionViewModels.element(at: indexPath.section),
              let finalSection = sectionViewModels.element(at: finalIndexPath.section),
              let cellViewModel = section.cellViewModels.element(at: indexPath.row) else {
            return
        }
        
        section.cellViewModels.remove(at: indexPath.row)
        finalSection.cellViewModels.insert(cellViewModel, at: finalIndexPath.row)
    }
    
    private func moveItem(from indexPath: IndexPath, to finalIndexPath: IndexPath) {
        guard let section = sections.element(at: indexPath.section),
              let finalSection = sections.element(at: finalIndexPath.section),
              let item = section.items.element(at: indexPath.row) else {
            return
        }
        
        section.items.remove(at: indexPath.row)
        finalSection.items.insert(item, at: finalIndexPath.row)
    }
}
