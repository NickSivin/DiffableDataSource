//
//  ProfileSection.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

typealias ProfileCellViewModel = TableCellViewModel & RectCornerConfigurable

class ProfileSectionCache {
    let propertiesSection = ProfilePropertiesSection()
    let notificationsSection = ProfileNotificationsSection()
    
    var sections: [DiffableDataSection] {
        return [propertiesSection, notificationsSection]
    }
    
    var sectionViewModels: [TableSectionViewModel] {
        return [
            CommonTableSectionViewModel(cellViewModels: propertiesSection.cellViewModels),
            CommonTableSectionViewModel(cellViewModels: notificationsSection.cellViewModels)
        ]
    }
}

class ProfilePropertiesSection: DiffableDataSection {
    var items: [DiffableDataItem] {
        set {}
        get {
            return allItems
        }
    }
    
    var cellViewModels: [ProfileCellViewModel] {
        return allItems.compactMap { $0.cellViewModel }
    }
    
    let phoneItem = ProfilePropertyItem()
    let emailItem = ProfilePropertyItem()
    
    private var allItems: [ProfilePropertyItem] {
        return [phoneItem, emailItem]
    }
}

class ProfileNotificationsSection: DiffableDataSection {
    var items: [DiffableDataItem] {
        set {}
        get {
            return allItems
        }
    }
    
    var cellViewModels: [ProfileCellViewModel] {
        return allItems.compactMap { $0.cellViewModel }
    }
    
    let allNotificationsItem = ProfileNotificationItem()
    var notificationItems: [ProfileNotificationItem] = []
    
    private var allItems: [ProfileNotificationItem] {
        return allNotificationsItem.isEnabled ? [allNotificationsItem] + notificationItems : [allNotificationsItem]
    }
}

class ProfilePropertyItem: DiffableDataItem {
    let tableIdentifier = UUID()
    var cellViewModel = ProfilePropertyCellViewModel(title: nil, value: nil)
}

class ProfileNotificationItem: DiffableDataItem {
    let tableIdentifier = UUID()
    var cellViewModel = ProfileSwitchCellViewModel(title: nil, isOn: false)
    
    var isEnabled: Bool {
        return cellViewModel.isOn
    }
}
