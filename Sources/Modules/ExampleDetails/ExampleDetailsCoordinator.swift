//
//  ExampleDetailsCoordinator.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

class ExampleDetailsCoordinator: BaseCoordinator {
    var childCoordinators: [BaseCoordinator] = []
    var onDidFinish: (() -> Void)?
    
    private let navigationController: UINavigationController
    private let example: Example
    
    init(navigationController: UINavigationController, example: Example) {
        self.navigationController = navigationController
        self.example = example
    }
    
    func start(animated: Bool) {
        showExampleDetailsScreen(animated: animated)
    }
    
    private func showExampleDetailsScreen(animated: Bool) {
        let viewModel = ExampleDetailsViewModel(mockDataSource: example.type.mockDataSource)
        let viewController = ExampleDetailsViewController(viewModel: viewModel)
        viewController.title = example.title
        navigationController.pushViewController(viewController, animated: true)
    }
}