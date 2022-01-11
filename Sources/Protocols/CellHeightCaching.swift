//
//  CellHeightCaching.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import CoreGraphics

protocol CellHeightCaching {
    var cachedHeight: CGFloat? { get set }
}
