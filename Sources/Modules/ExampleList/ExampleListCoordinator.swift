//
//  ExampleListCoordinator.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

class ExampleListCoordinator: BaseCoordinator {
    var childCoordinators: [BaseCoordinator] = []
    var onDidFinish: (() -> Void)?
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool) {
        showExampleListScreen(animated: animated)
    }
    
    private func showExampleListScreen(animated: Bool) {
        let viewModel = ExampleListViewModel()
        viewModel.delegate = self
        let viewController = ExampleListViewController(viewModel: viewModel)
        viewController.title = Localized.exampleList.string(forKey: .title)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showExampleDetailsScreen(example: Example) {
        let coordinator = ExampleDetailsCoordinator(navigationController: navigationController, example: example)
        add(child: coordinator)
        coordinator.delegate = self
        coordinator.start(animated: true)
    }
}

// MARK: - ExampleListViewModelDelegate
extension ExampleListCoordinator: ExampleListViewModelDelegate {
    func exampleListViewModel(_ viewModel: ExampleListViewModel, didSelectExample example: Example) {
        showExampleDetailsScreen(example: example)
    }
}


// MARK: - ExampleDetailsCoordinatorDelegate
extension ExampleListCoordinator: ExampleDetailsCoordinatorDelegate {
    func exampleDetailsCoordinatorDidFinish(_ coordinator: ExampleDetailsCoordinator) {
        coordinator.onDidFinish?()
    }
}
