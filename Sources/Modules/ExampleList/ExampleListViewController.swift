//
//  ExampleListViewController.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

class ExampleListViewController: BaseViewController {
    // MARK: - Properties
    let tableView = UITableView()
    let viewModel: ExampleListViewModel
    
    private let tableDataController: TableDataController
    
    init(viewModel: ExampleListViewModel) {
        self.viewModel = viewModel
        self.tableDataController = CommonTableDataController(tableView: tableView, viewModel: viewModel)
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
        view.backgroundColor = .background
        setupTableView()
        viewModel.loadData()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.constraintsSupport.makeConstraints { make in
            make.edgesEqualTo(view)
        }
        
        tableView.register(ExampleCell.self, forCellReuseIdentifier: ExampleCell.reuseIdentifier)
    }
}
