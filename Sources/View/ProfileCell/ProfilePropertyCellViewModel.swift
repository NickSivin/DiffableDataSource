//
//  ProfilePropertyCellViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

class ProfilePropertyCellViewModel: TableCellViewModel, RectCornerConfigurable {
    var onDidUpdate: (() -> Void)?
    
    var reuseIdentifier: String {
        return ProfilePropertyCell.reuseIdentifier
    }
    
    var title: String? {
        didSet {
            onDidUpdate?()
        }
    }
    
    var value: String? {
        didSet {
            onDidUpdate?()
        }
    }
    
    var rectCorner: UIRectCorner?
    
    init(title: String?, value: String?) {
        self.title = title
        self.value = value
    }
}
