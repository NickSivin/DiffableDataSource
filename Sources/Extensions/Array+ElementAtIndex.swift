//
//  Array+ElementAtIndex.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

extension Array {
    func element(at index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
}
