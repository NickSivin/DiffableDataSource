//
//  ExampleDetailsViewController.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

class ExampleDetailsViewController: BaseViewController {
    // MARK: - Properties
    private let tableView = UITableView()
    private let tableDataController: TableDataController
    
    private let viewModel: ExampleDetailsViewModel
    
    // MARK: - Init
    init(viewModel: ExampleDetailsViewModel) {
        self.viewModel = viewModel
        self.tableDataController = CommonTableDataController(tableView: tableView, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private
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
        tableView.register(PaginationCell.self, forCellReuseIdentifier: PaginationCell.reuseIdentifier)
        tableView.register(ExampleHeaderView.self, forHeaderFooterViewReuseIdentifier: ExampleHeaderView.reuseIdentifier)
    }
}
