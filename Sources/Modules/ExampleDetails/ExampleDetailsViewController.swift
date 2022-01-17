//
//  ExampleDetailsViewController.swift
//  DiffableDataSource
//
//  Created by Nick Sivin.
//

import UIKit

protocol ExampleDetailsViewControllerDelegate: AnyObject {
    func exampleDetailsViewControllerDidFinish(_ viewController: ExampleDetailsViewController)
}

class ExampleDetailsViewController: BaseViewController {
    // MARK: - Properties
    weak var delegate: ExampleDetailsViewControllerDelegate?
    
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
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        guard parent == nil else { return }
        delegate?.exampleDetailsViewControllerDidFinish(self)
    }
    
    // MARK: - Private
    private func setup() {
        view.backgroundColor = .background
        setupTableView()
        bindToViewModel()
        viewModel.loadData()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.constraintsSupport.makeConstraints { make in
            make.edgesEqualTo(view)
        }
        
        tableView.register(ExampleCell.self, forCellReuseIdentifier: ExampleCell.reuseIdentifier)
        tableView.register(PaginationCell.self, forCellReuseIdentifier: PaginationCell.reuseIdentifier)
        tableView.register(ProfilePropertyCell.self, forCellReuseIdentifier: ProfilePropertyCell.reuseIdentifier)
        tableView.register(ProfileSwitchCell.self, forCellReuseIdentifier: ProfileSwitchCell.reuseIdentifier)
        tableView.register(ExampleHeaderView.self, forHeaderFooterViewReuseIdentifier: ExampleHeaderView.reuseIdentifier)
    }
    
    private func bindToViewModel() {
        viewModel.onDidUpdate = { [weak self] in
            self?.addProfileHeaderIfNeeded()
            self?.updateProfileHeaderView()
        }
    }
    
    private func addProfileHeaderIfNeeded() {
        guard tableView.tableHeaderView == nil,
              let profileHeaderViewModel = viewModel.profileHeaderViewModel else {
                  return
        }
        
        let view = ProfileHeaderView()
        view.configure(viewModel: profileHeaderViewModel)
        tableView.tableHeaderView = view
        
        view.constraintsSupport.makeConstraints { make in
            make.topEqualTo(tableView)
            make.widthEqualTo(tableView)
            make.centerEqualTo(tableView, anchor: .xAnchor)
        }
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        tableView.tableHeaderView = view
    }
    
    private func updateProfileHeaderView() {
        guard let view = tableView.tableHeaderView as? ProfileHeaderView,
              let profileHeaderViewModel = viewModel.profileHeaderViewModel else {
                  return
        }
        view.configure(viewModel: profileHeaderViewModel)
    }
}
