//
//  ReuseIdentifiable.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol ReuseIdentifiable {
  static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

extension UITableViewCell: ReuseIdentifiable { }
extension UITableViewHeaderFooterView: ReuseIdentifiable { }
extension UICollectionReusableView: ReuseIdentifiable { }
