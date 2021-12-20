//
//  AppDelegate.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private lazy var mainCoordinator = makeMainCoordinator()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        mainCoordinator.start(animated: true)
        return true
    }
    
    private func makeMainCoordinator() -> MainCoordinator {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        return MainCoordinator(window: window)
    }
}

