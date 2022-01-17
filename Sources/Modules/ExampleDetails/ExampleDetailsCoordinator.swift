//
//  ExampleDetailsCoordinator.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol ExampleDetailsCoordinatorDelegate: AnyObject {
    func exampleDetailsCoordinatorDidFinish(_ coordinator: ExampleDetailsCoordinator)
}

class ExampleDetailsCoordinator: BaseCoordinator {
    weak var delegate: ExampleDetailsCoordinatorDelegate?
    
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
        let viewModel = makeExampleDetailsViewModel()
        let viewController = ExampleDetailsViewController(viewModel: viewModel)
        viewController.delegate = self
        viewController.title = example.title
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func makeExampleDetailsViewModel() -> ExampleDetailsViewModel {
        switch example.type {
        case .pagination:
            return PaginationExampleViewModel()
        case .dragAndDrop:
            return DragAndDropExampleViewModel()
        case .profile:
            return ProfileExampleViewModel()
        }
    }
}

// MARK: - ExampleDetailsViewControllerDelegate
extension ExampleDetailsCoordinator: ExampleDetailsViewControllerDelegate {
    func exampleDetailsViewControllerDidFinish(_ viewController: ExampleDetailsViewController) {
        delegate?.exampleDetailsCoordinatorDidFinish(self)
    }
}
