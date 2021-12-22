//
//  ExampleListViewController.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

class ExampleListViewController: BaseViewController, CommonTableViewContainer {
    // MARK: - Properties
    let tableView = UITableView()
    let viewModel: ExampleListViewModel
    
    init(viewModel: ExampleListViewModel) {
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
