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
        // TODO: Start initial module
    }
}
