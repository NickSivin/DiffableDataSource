//
//  Profile.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

struct Profile {
    let image: ImageAsset.ImageName
    let name: String
    let phone: String
    let email: String
    var isNotificationsEnabled: Bool
    let notifications: [Notification]
}

struct Notification {
    let type: NotificationType
    let isEnabled: Bool
}

enum NotificationType {
    case feed
    case messages
    case settings
}
