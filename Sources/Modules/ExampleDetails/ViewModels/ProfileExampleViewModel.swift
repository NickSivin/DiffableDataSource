//
//  ProfileExampleViewModel.swift
//  DiffableDataSource
//
//  Created by Никита Nick Sivin.
//

import Foundation

class ProfileExampleViewModel: ExampleDetailsViewModel {
    var onDidUpdate: (() -> Void)?
    var profileHeaderViewModel: ProfileHeaderViewModel?
    
    var tableDataSource: TableViewDiffableDataSource?
    
    var sectionViewModels: [TableSectionViewModel] {
        return sectionsCache.sectionViewModels
    }
    
    private let sectionsCache = ProfileSectionCache()
    private let mockDataSource = ProfileMockDataSource()
    private var cursor: String?
    private var isLoading = false
    
    private let profileMockDataSource = ProfileMockDataSource()
    private var profile: Profile?
    
    func loadData() {
        guard !isLoading else { return }
        isLoading = true
        profileMockDataSource.getMockData { [weak self] profile in
            guard let self = self else { return }
            self.isLoading = false
            self.profile = profile
            self.updateTableData(animating: false)
        }
    }
    
    func updateTableData(animating: Bool) {
        updateProfileData()
        updateTableDataSource(animating: animating)
    }
    
    private func updateProfileData() {
        updateProfileHeader()
        updatePhone()
        updateEmail()
        updateNotifications()
        updateRectCorners()
    }
    
    private func updateProfileHeader() {
        profileHeaderViewModel = ProfileHeaderViewModel(image: profile?.image, name: profile?.name)
    }
    
    private func updatePhone() {
        let viewModel = sectionsCache.propertiesSection.phoneItem.cellViewModel
        viewModel.title = Localized.exampleDetails.string(forKey: .propertyPhone)
        viewModel.value = profile?.phone
    }
    
    private func updateEmail() {
        let viewModel = sectionsCache.propertiesSection.emailItem.cellViewModel
        viewModel.title = Localized.exampleDetails.string(forKey: .propertyEmail)
        viewModel.value = profile?.email
    }
    
    private func updateNotifications() {
        let notificationsSection = sectionsCache.notificationsSection
        
        let allNotificationsViewModel = notificationsSection.allNotificationsItem.cellViewModel
        allNotificationsViewModel.title = Localized.exampleDetails.string(forKey: .notificationAll)
        allNotificationsViewModel.isOn = profile?.isNotificationsEnabled == true
        
        allNotificationsViewModel.onDidRequestChangeValue = { [weak self] isOn in
            self?.profile?.isNotificationsEnabled = isOn
            self?.updateTableDataSource(animating: true)
            self?.updateRectCorners()
        }
        
        notificationsSection.notificationItems = profile?.notifications.map { notification in
            let item = ProfileNotificationItem()
            item.cellViewModel.title = getTitle(for: notification)
            item.cellViewModel.isOn = notification.isEnabled
            item.cellViewModel.onDidRequestChangeValue = { _ in
                // Send request
            }
            return item
        } ?? []
    }
    
    private func updateTableDataSource(animating: Bool) {
        tableDataSource?.updateData(sections: sectionsCache.sections,
                                    rowAnimation: animating ? .top : .none,
                                    animating: animating)
        onDidUpdate?()
    }
    
    private func getTitle(for notification: Notification) -> String {
        let localized = Localized.exampleDetails.self
        switch notification.type {
        case .feed:
            return localized.string(forKey: .notificationFeed)
        case .messages:
            return localized.string(forKey: .notificationMessages)
        case .settings:
            return localized.string(forKey: .notificationSettings)
        }
    }
    
    private func updateRectCorners() {
        setupRectCorners(for: sectionsCache.propertiesSection.cellViewModels)
        setupRectCorners(for: sectionsCache.notificationsSection.cellViewModels)
    }
    
    private func setupRectCorners(for items: [RectCornerConfigurable]) {
        guard items.count > 1 else {
            items.first?.rectCorner = .allCorners
            return
        }
        
        items.forEach { $0.rectCorner = nil }
        items.first?.rectCorner = [.topLeft, .topRight]
        items.last?.rectCorner = [.bottomLeft, .bottomRight]
    }
}
