//
//  ProfileMockDataSource.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation

class ProfileMockDataSource {
    func getMockData(completion: @escaping ((Profile) -> Void)) {
        let profile = Profile(image: .profileImage,
                              name: "User Name",
                              phone: "+7 (123) 456 78 90",
                              email: "user@email.com",
                              isNotificationsEnabled: .random(),
                              notifications: makeNotifications())
        completion(profile)
    }
    
    private func makeNotifications() -> [Notification] {
        return [
            Notification(type: .feed, isEnabled: .random()),
            Notification(type: .messages, isEnabled: .random()),
            Notification(type: .settings, isEnabled: .random())
        ]
    }
}
