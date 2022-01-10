//
//  ExampleListViewController.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

class ExampleListViewController: BaseViewController, TableViewContainer {
    // MARK: - Properties
    let tableView = UITableView()
    let viewModel: ExampleListViewModel
    
    private lazy var dataSource = makeTableViewDiffableDataSource()
    
    init(viewModel: ExampleListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        viewModel.dataSource = dataSource
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.constraintsSupport.makeConstraints { make in
            make.edgesEqualTo(view)
        }
    }
}
