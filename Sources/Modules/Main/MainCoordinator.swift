//
//  MainCoordinator.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import Foundation
import UIKit

class MainCoordinator: BaseCoordinator {
    var childCoordinators: [BaseCoordinator] = []
    var onDidFinish: (() -> Void)?
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start(animated: Bool) {
        let coordinator = ExampleListCoordinator(navigationController: navigationController)
        add(child: coordinator)
        coordinator.start(animated: animated)
        
        UINavigationBar.appearance().tintColor = .base3
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.base1]
    }
}
