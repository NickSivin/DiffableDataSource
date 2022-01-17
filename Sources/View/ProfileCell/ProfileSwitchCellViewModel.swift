//
//  ProfileSwitchCellViewModel.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation
import UIKit

class ProfileSwitchCellViewModel: TableCellViewModel, RectCornerConfigurable {
    var onDidUpdate: (() -> Void)?
    var onDidRequestChangeValue: ((Bool) -> Void)?
    
    var reuseIdentifier: String {
        return ProfileSwitchCell.reuseIdentifier
    }
    
    var title: String? {
        didSet {
            onDidUpdate?()
        }
    }
    
    var isOn: Bool {
        didSet {
            onDidUpdate?()
        }
    }
    
    var rectCorner: UIRectCorner? {
        didSet {
            onDidUpdate?()
        }
    }
    
    init(title: String?, isOn: Bool) {
        self.title = title
        self.isOn = isOn
    }
    
    func changeValue(_ isOn: Bool) {
        self.isOn = isOn
        onDidRequestChangeValue?(isOn)
    }
}
