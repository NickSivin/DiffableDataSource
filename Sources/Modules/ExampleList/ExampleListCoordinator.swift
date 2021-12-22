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
    
    private func showDetailsScreen(exampleDetailsConfiguration: ExampleDetailsConfiguration) {
        
    }
}
